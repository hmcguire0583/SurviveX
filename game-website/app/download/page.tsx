import React, { JSX } from 'react';
import Link from 'next/link';
import DownloadSection from '../components/DownloadSection';

export const metadata = {
  title: 'Download - SurviveX',
  description: 'Download SurviveX builds and access the web demo.',
};

export default function DownloadPage(): JSX.Element {
  return (
    <main style={{ backgroundColor: '#0d0d0d', color: '#f5f5f5', minHeight: '100vh', padding: 36 }}>
      {/* Fixed modern 'Go back' button in top-left */}
      <div style={{ position: 'fixed', top: 12, left: 12, zIndex: 60 }}>
        <Link
          href="/"
          aria-label="Go back to home"
          title="Go back to home"
          className="inline-flex items-center justify-center"
          style={{
            width: 56,
            height: 56,
            borderRadius: 9999,
            background: 'linear-gradient(180deg, rgba(12,36,30,0.9), rgba(6,18,16,0.9))',
            color: '#7ef5c6',
            boxShadow: '0 8px 24px rgba(2,10,8,0.6)',
            textDecoration: 'none',
            display: 'inline-flex',
            alignItems: 'center',
            justifyContent: 'center',
            transition: 'transform 160ms ease, box-shadow 160ms ease',
          }}
        >
          {/* SVG left arrow */}
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden>
            <path d="M15 18l-6-6 6-6" stroke="#7ef5c6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        </Link>
      </div>

      <div className="max-w-4xl mx-auto px-6 py-12" style={{ paddingTop: 40 }}>
        {/* Reuse the DownloadSection content */}
        <DownloadSection />
      </div>
    </main>
  );
}