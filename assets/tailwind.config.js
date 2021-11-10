module.exports = {
  mode: 'jit',
  purge: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex',
  ],
  darkMode: 'media', // or 'media' or 'class'
  theme: {
    screens: {
      'xs': '440px',
      'sm': '675px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
    },
    fontFamily: {
      display: ['Inter', 'system-ui', 'Arial', 'sans-serif'],
      body: ['Inter', 'system-ui', 'Arial', 'sans-serif'],
    },
    fontSize: {
      'xs': '.75rem',
      'sm': '.875rem',
      'base': '1rem',
      'lg': '1.125rem',
      'xl': '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': '2.25rem',
      '5xl': '3rem',
      '6xl': '3.75rem',
      '7xl': '4.5rem',
      '8xl': '6rem',
      '9xl': '8rem',
      '10xl': '13rem',
      '11xl': '25rem',
    },
    minHeight: {
      '0': '0',
      '1/4': '25%',
      '1/2': '50%',
      '3/4': '75%',
      'sm': '230px',
      'md': '400px',
      'xl': '600px',
      '2xl': '900px',
      'full': '100%',
      'screen': '100vh'
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
