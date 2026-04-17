/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: '#030405',
        primary: {
          DEFAULT: '#c5a880',
          light: '#dfc8a5',
        },
        secondary: '#0f1116',
        accent: '#45a29e',
        danger: '#e94560',
        safe: '#2ecc71',
      },
      backgroundImage: {
        'gold-gradient': 'linear-gradient(135deg, #c5a880 0%, #ebd3a8 100%)',
      },
      backdropBlur: {
        '3xl': '30px',
      }
    },
  },
  plugins: [],
}
