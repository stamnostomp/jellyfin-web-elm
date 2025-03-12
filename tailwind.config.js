// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/index.html',
    './src/**/*.elm'
  ],
  theme: {
    // Extend the default Tailwind theme
    extend: {
      colors: {
        // Everbush Vim theme colors
        primary: {
          light: '#7fa8cc', // Lighter blue
          DEFAULT: '#5f87af', // Blue-ish
          dark: '#4a6d8c', // Darker blue
        },
        secondary: {
          light: '#e0a0a0', // Lighter pink
          DEFAULT: '#d78787', // Soft red/pink
          dark: '#af6c6c', // Darker pink
        },
        // UI colors based on Everbush
        background: {
          light: '#303030', // Selection color
          DEFAULT: '#1c1c1c', // Dark background
          dark: '#141414', // Even darker
        },
        surface: {
          light: '#303030', // Selection color
          DEFAULT: '#262626', // Line highlight color
          dark: '#1c1c1c', // Background color
        },
        text: {
          primary: '#d0d0d0', // Light text
          secondary: '#a0a0a0', // Slightly dimmer text
          disabled: '#5f5f5f', // Muted text
        },
        success: {
          light: '#a3c5a3', // Lighter green
          DEFAULT: '#87af87', // Soft green
          dark: '#6c8c6c', // Darker green
        },
        warning: {
          light: '#e0e0a0', // Lighter yellow
          DEFAULT: '#d7d787', // Soft yellow
          dark: '#acac6c', // Darker yellow
        },
        error: {
          light: '#c58787', // Lighter red
          DEFAULT: '#af5f5f', // Error red
          dark: '#8c4c4c', // Darker red
        },
        info: {
          light: '#afafc5', // Lighter purple
          DEFAULT: '#af87af', // Soft purple
          dark: '#8c6c8c', // Darker purple
        },
        // Additional Everbush theme colors
        comment: '#87875f', // Olive for comments
        accent: '#d7875f', // Orange for accents
      },
      fontFamily: {
        mono: ['IBM Plex Mono', ...defaultTheme.fontFamily.mono],
        sans: ['IBM Plex Sans', ...defaultTheme.fontFamily.sans],
      },
      // Add subtle background patterns inspired by code editors
      backgroundImage: {
        'subtle-grid': 'linear-gradient(#303030 1px, transparent 1px), linear-gradient(to right, #303030 1px, transparent 1px)',
      },
      backgroundSize: {
        'grid-size': '32px 32px',
      },
    },
  },
  // Create custom utility classes if needed
  plugins: [],
}
