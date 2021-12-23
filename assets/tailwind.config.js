module.exports = {
  mode: 'jit',
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex',
  ],
  darkMode: 'media', // 'false' or 'media' or 'class'
  theme: {
    screens: {
      'xs': '440px',
      'sm': '675px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
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
    extend: {
      colors: {
        gray: {
          850: '#1C2631'
        },
        code: {
          gray: '#adadad',
          black: '#1b1c1d',
          purple: '#0d121d'
        }
      },
      transitionProperty: {        'height': 'height',        'spacing': 'margin, padding',      },
      fontFamily: {
        roboto: ['Roboto', 'Arial', 'ui-sans-serif', 'system-ui', 'Inter', 'sans-serif'],
        serif: ['Merriweather', 'Lora', 'ui-serif', 'serif'],      
        mono: ['ui-monospace', 'DejaVu LGC Sans Code', 'DejaVu Sans Code', 'DejaVu Sans Mono', 'SFMono-Regular', 'monospace'],
        display: ['Arial', 'system-ui', 'Inter', 'sans-serif'],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
