"use client";

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import DownloadSection from './DownloadSection';

export default function GamePage() {
  const router = useRouter();
  return (
    <main style={{ backgroundColor: '#0d0d0d', color: '#f5f5f5' }}>
      <header style={{
        background: '#111',
        padding: '16px 40px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottom: '1px solid #333'
      }}>
        <Link href="/" className="site-logo" style={{ fontSize: '2.5rem', color: '#00ff7f', letterSpacing: '1px', margin: 0, textDecoration: 'none' }}>SurviveX</Link>
      </header>

      <div style={{
        height: '90vh',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'column',
        textAlign: 'center'
      }}>
        <h2 style={{ fontSize: '5rem', marginBottom: '20px' }}>Fight. Craft. Survive.</h2>
        <p style={{ fontSize: '1.8rem', marginBottom: '30px', color: '#ccc', fontWeight: 'bold' }}>
          Build shelter, hunt for food, and survive the wilderness.
        </p>

  {/* Play button with pulsing glow + hover/focus effects. Use router.push to ensure navigation triggers. */}
  <button
    type="button"
    className="play-btn"
    aria-label="Go to downloads"
    onClick={() => router.push('/download')}
  >
    Play Now
  </button>

        <style>{`
          .play-btn {
            background: linear-gradient(90deg,#7bf7a4,#22c55e);
            color: #052016;
            padding: 24px 36px;
            border: none;
            border-radius: 10px;
            font-weight: 800;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.45);
            transform: translateZ(0);
            transition: transform 180ms cubic-bezier(.2,.9,.3,1), box-shadow 180ms ease;
            animation: pulse 2.4s infinite ease-in-out;
          }

          .play-btn:hover {
            transform: scale(1.06);
            box-shadow: 0 10px 30px rgba(34,197,94,0.18);
            animation-play-state: paused; /* subtle pause on hover */
          }

          .play-btn:active {
            transform: scale(0.98);
            box-shadow: 0 6px 16px rgba(0,0,0,0.45);
          }

          .play-btn:focus {
            outline: none;
            box-shadow: 0 0 0 6px rgba(34,197,94,0.12), 0 8px 24px rgba(0,0,0,0.5);
          }

          @keyframes pulse {
            0% {
              box-shadow: 0 6px 18px rgba(0,0,0,0.45), 0 0 0 0 rgba(34,197,94,0.18);
              transform: translateY(0) scale(1);
            }
            50% {
              box-shadow: 0 10px 30px rgba(34,197,94,0.10), 0 0 28px 8px rgba(34,197,94,0.06);
              transform: translateY(-3px) scale(1.02);
            }
            100% {
              box-shadow: 0 6px 18px rgba(0,0,0,0.45), 0 0 0 0 rgba(34,197,94,0.0);
              transform: translateY(0) scale(1);
            }
          }
        `}</style>
      </div>

      {/* In-page sections (home anchors) */}

      {/* Download / Install section that Play Now links to */}
      {/* Imported DownloadSection component for reuse */}
      <DownloadSection />
    </main>
  );
}