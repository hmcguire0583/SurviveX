"use client";

import { useRouter } from 'next/navigation';

export default function GamePage() {
  const router = useRouter();
  return (
    <main style={{ color: '#f5f5f5' }}>
      <div style={{
        height: '90vh',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'column',
        textAlign: 'center'
      }}>
        <h2 className="hero-title" style={{ fontSize: '6rem', marginBottom: '20px', fontFamily: '\'Super Crawler\', cursive' }}>Fight. Craft. Survive.</h2>
        <p style={{ fontSize: '2rem', marginBottom: '30px', color: '#d4d4d4', fontWeight: '800' }}>
          Forge weapons, travel islands, and survive the night.
        </p>

  {/* Play button with pulsing glow + hover/focus effects */}
  <button className="play-btn" aria-label="Play the game" type="button" onClick={() => router.push('/download')}>Play Now</button>

        <style>{`
          .play-btn {
            background: linear-gradient(90deg, #3b82f6, #1e40af);
            color: #ffffff;
            padding: 36px 48px;
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
            box-shadow: 0 10px 30px rgba(59,130,246,0.4);
            animation-play-state: paused; /* subtle pause on hover */
          }

          .play-btn:active {
            transform: scale(0.98);
            box-shadow: 0 6px 16px rgba(0,0,0,0.45);
          }

          .play-btn:focus {
            outline: none;
            box-shadow: 0 0 0 6px rgba(59,130,246,0.3), 0 8px 24px rgba(0,0,0,0.5);
          }

          @keyframes pulse {
            0% {
              box-shadow: 0 6px 18px rgba(0,0,0,0.45), 0 0 0 0 rgba(59,130,246,0.4);
              transform: translateY(0) scale(1);
            }
            50% {
              box-shadow: 0 10px 30px rgba(59,130,246,0.3), 0 0 28px 8px rgba(59,130,246,0.2);
              transform: translateY(-3px) scale(1.02);
            }
            100% {
              box-shadow: 0 6px 18px rgba(0,0,0,0.45), 0 0 0 0 rgba(59,130,246,0.0);
              transform: translateY(0) scale(1);
            }
          }
        `}</style>
      </div>

      {/* Sections have been moved to their own pages: /background, /team, /bibliography */}

    </main>
  );
}