// app/javascript/controllers/call_controller.js
import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
    static targets = ["remoteAudio", "localAudio", "acceptButton", "declineButton", "endButton", "muteButton", "timer"]

    connect() {
        this.callId = this.element.dataset.callId
        this.peerConnection = null
        this.localStream = null
        this.remoteStream = null
        this.channel = null
        this.timerInterval = null
        this.callDuration = 0

        // Initialize WebRTC if this is an active call
        if (this.hasRemoteAudioTarget) {
            this.initializeWebRTC()
        }
    }

    disconnect() {
        this.endCall()
    }

    async initializeWebRTC() {
        // Set up WebRTC peer connection
        const configuration = { iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] }
        this.peerConnection = new RTCPeerConnection(configuration)

        // Handle incoming tracks
        this.peerConnection.ontrack = (event) => {
            this.remoteAudioTarget.srcObject = event.streams[0]
        }

        // Set up ICE candidate handling
        this.peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                this.sendIceCandidate(event.candidate)
            }
        }

        // Get local audio stream
        try {
            this.localStream = await navigator.mediaDevices.getUserMedia({ audio: true, video: false })

            // Add local tracks to peer connection
            this.localStream.getTracks().forEach(track => {
                this.peerConnection.addTrack(track, this.localStream)
            })

            // If we have a local audio element, connect it
            if (this.hasLocalAudioTarget) {
                this.localAudioTarget.srcObject = this.localStream
            }

            // Connect to WebRTC channel
            this.connectToChannel()

            // Create and send offer if we're the caller
            const callElement = this.element
            if (callElement.classList.contains('call-status')) {
                this.createOffer()
            }

            // Start call timer
            this.startTimer()
        } catch (error) {
            console.error("Error accessing media devices.", error)
        }
    }

    connectToChannel() {
        this.channel = consumer.subscriptions.create(
            { channel: "WebrtcChannel", call_id: this.callId },
            {
                connected: () => console.log("Connected to WebRTC channel"),
                disconnected: () => console.log("Disconnected from WebRTC channel"),
                received: (data) => this.handleChannelData(data)
            }
        )
    }

    handleChannelData(data) {
        if (data.type === 'ice_candidate' && data.sender_id !== this.getCurrentUserId()) {
            this.addIceCandidate(data.candidate)
        } else if (data.type === 'session_description' && data.sender_id !== this.getCurrentUserId()) {
            this.handleSessionDescription(data.description)
        }
    }

    async createOffer() {
        try {
            const offer = await this.peerConnection.createOffer()
            await this.peerConnection.setLocalDescription(offer)
            this.sendSessionDescription(this.peerConnection.localDescription)
        } catch (error) {
            console.error("Error creating offer", error)
        }
    }

    async handleSessionDescription(description) {
        try {
            await this.peerConnection.setRemoteDescription(new RTCSessionDescription(description))

            // If this is an offer, we need to create an answer
            if (description.type === 'offer') {
                const answer = await this.peerConnection.createAnswer()
                await this.peerConnection.setLocalDescription(answer)
                this.sendSessionDescription(this.peerConnection.localDescription)
            }
        } catch (error) {
            console.error("Error handling session description", error)
        }
    }

    async addIceCandidate(candidate) {
        try {
            await this.peerConnection.addIceCandidate(new RTCIceCandidate(candidate))
        } catch (error) {
            console.error("Error adding ICE candidate", error)
        }
    }

    sendIceCandidate(candidate) {
        this.channel.perform('ice_candidate', {
            call_id: this.callId,
            candidate: candidate
        })
    }

    sendSessionDescription(description) {
        this.channel.perform('session_description', {
            call_id: this.callId,
            description: description
        })
    }

    async accept(event) {
        event.preventDefault()

        // Send the accept request through Rails
        const url = this.acceptButton.getAttribute('formaction')
        const response = await fetch(url, {
            method: 'PATCH',
            headers: {
                'X-CSRF-Token': this.getCSRFToken()
            }
        })

        // Initialize WebRTC after the server acknowledges the call is active
        if (response.ok) {
            this.initializeWebRTC()
        }
    }

    async end(event) {
        if (event) event.preventDefault()

        // End call in Rails first
        if (this.hasEndButtonTarget) {
            const url = this.endButton.getAttribute('formaction')
            await fetch(url, {
                method: 'PATCH',
                headers: {
                    'X-CSRF-Token': this.getCSRFToken()
                }
            })
        }

        this.endCall()
    }

    endCall() {
        // Stop all media tracks
        if (this.localStream) {
            this.localStream.getTracks().forEach(track => track.stop())
        }

        // Close peer connection
        if (this.peerConnection) {
            this.peerConnection.close()
        }

        // Disconnect channel
        if (this.channel) {
            this.channel.unsubscribe()
        }

        // Stop timer
        if (this.timerInterval) {
            clearInterval(this.timerInterval)
        }
    }

    toggleMute() {
        if (this.localStream) {
            const audioTrack = this.localStream.getAudioTracks()[0]
            if (audioTrack) {
                audioTrack.enabled = !audioTrack.enabled
                this.muteButtonTarget.textContent = audioTrack.enabled ? 'Mute' : 'Unmute'
            }
        }
    }

    startTimer() {
        if (this.hasTimerTarget) {
            this.callDuration = 0
            this.updateTimer()
            this.timerInterval = setInterval(() => {
                this.callDuration++
                this.updateTimer()
            }, 1000)
        }
    }

    updateTimer() {
        const minutes = Math.floor(this.callDuration / 60)
        const seconds = this.callDuration % 60
        this.timerTarget.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
    }

    getCurrentUserId() {
        // This would need to be set in your application layout
        return parseInt(document.body.dataset.userId)
    }

    getCSRFToken() {
        return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
}