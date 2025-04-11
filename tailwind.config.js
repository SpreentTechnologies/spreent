/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        './app/**/*.{erb,rb,html}',
        './app/views/**/*.{erb,html,html.erb,rb}',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/javascript/**/*.jsx',
        './app/assets/builds/**/*.js',
        './app/components/**/*.{erb,rb}', // For view_component users
        './lib/components/**/*.{erb,rb}', // For some component approaches
        './config/initializers/simple_form_tailwind.rb', // If using simple_form
    ],
    theme: {

    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/aspect-ratio'),
        // Add any additional plugins you want to use
    ],
    // Add any variants configurations if needed
    safelist: [
        // Add any classes that might be dynamically generated and need to be included
        // Example: 'bg-red-500', 'text-green-400'
    ],
}