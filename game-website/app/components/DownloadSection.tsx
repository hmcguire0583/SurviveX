import React from 'react';

export default function DownloadSection() {
  return (
    <>
      <section
        id="Download"
        aria-labelledby="Download-title"
        style={{
          maxWidth: 980,
          margin: '40px auto',
          padding: 28,
          borderRadius: 12,
          background: 'linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01))',
          border: '1px solid rgba(255,255,255,0.03)',
        }}
      >
        <h2 id="Download-title" style={{ marginTop: 0, color: '#e9fff0', fontSize: '2rem' }}>
          Download
        </h2>
        <p style={{ color: '#cfe9dd', lineHeight: 1.6 }}>
          You can download the latest Windows build of SurviveX as a ZIP file. Additionally, we offer a web demo that allows you to play the game directly in your browser without any installation.
        </p>
        <div style={{ marginTop: 20 }}>
          <h3 style={{ color: '#e9fff0', fontSize: '1.25rem', marginBottom: 12 }}>
            Available Downloads
          </h3>
          <p style={{ color: '#bcd9cf', marginTop: 12 }}>
            <a
              href="/downloads/SurviveX_Windows.zip"
              download="SurviveX_Windows.zip"
              style={{
                color: '#87ceeb',
                textDecoration: 'underline',
                fontWeight: 'bold',
              }}
            >
              Download for Windows (ZIP)
            </a>
          </p>
        </div>
      </section>

      <section
        id="PlayInBrowser"
        aria-labelledby="PlayInBrowser-title"
        style={{
          maxWidth: 980,
          margin: '40px auto',
          padding: 28,
          borderRadius: 12,
          background: 'linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01))',
          border: '1px solid rgba(255,255,255,0.03)',
        }}
      >
        <h2 id="PlayInBrowser-title" style={{ marginTop: 0, color: '#e9fff0', fontSize: '2rem' }}>
          Play in Browser
        </h2>
        <p style={{ color: '#cfe9dd', lineHeight: 1.6 }}>
          Try SurviveX directly in your browser - no download required.
        </p>
        <p style={{ color: '#bcd9cf', marginTop: 12 }}>
          <a
            href="/prototype/SurviveX.html"
            target="_blank"
            rel="noopener noreferrer"
            style={{
              color: '#87ceeb',
              textDecoration: 'underline',
              fontWeight: 'bold',
            }}
          >
            Play SurviveX in Browser
          </a>
        </p>
      </section>
    </>
  );
}