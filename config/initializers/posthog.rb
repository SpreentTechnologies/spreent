$posthog = PostHog::Client.new(
  api_key: 'phc_MTEDYMT3VxmLUK30Cvno1b3So27daWvfJBrOWt31hCb',
  host: 'https://us.i.posthog.com',
  on_error: Proc.new { |status, msg| print msg }
)
