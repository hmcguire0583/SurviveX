import React from 'react';
import Image from 'next/image';

export default function BackgroundSection() {
  return (
    <>
      <section id="background" aria-labelledby="background-title" style={{ maxWidth: 980, margin: '40px auto', padding: 28, borderRadius: 12, background: 'linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01))', border: '1px solid rgba(255,255,255,0.03)' }}>
          <h2 id="background-title" style={{ marginTop: 0, color: '#e9fff0', fontSize: '2rem' }}>Overview</h2>
          <p style={{ color: '#cfe9dd', lineHeight: 1.6 }}>
              SurviveX is a top-down 2D math survival game where players explore a dynamic ocean world filled with islands, zombies, and shark attacks that are all powered by solving math problems. Designed for 8th-grade learners, the game blends adventure and education: players navigate using slope and distance calculations, battle enemies by answering equations, and earn resources to upgrade gear. With a real-time day/night cycle and adaptive difficulty, SurviveX turns math into a tool for survival, strategy, and progression.
          </p>
      </section>

      <section id="motivation" aria-labelledby="motivation-title" style={{ maxWidth: 980, margin: '40px auto', padding: 28, borderRadius: 12, background: 'linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01))', border: '1px solid rgba(255,255,255,0.03)' }}>
          <h2 id="motivation-title" style={{ marginTop: 0, color: '#e9fff0', fontSize: '2rem' }}>Motivation</h2>
            <p style={{ color: '#cfe9dd', lineHeight: 1.6 }}>
              The motivation for this game came from our final project during the first run of the Software Engineering course at UMass Lowell. We wanted to build something fun but meaningful, so we took inspiration from survival games, especially the Steam game <em>Raft</em>, and added an educational twist. The idea was to make math feel like a tool for survival, not just something you do in class. By blending gameplay with real math concepts, we aimed to create something that’s both engaging and useful for middle school students.

            </p>
      </section>

      <section id="demo" aria-labelledby="demo-title" style={{ maxWidth: 980, margin: '40px auto', padding: 28, borderRadius: 12, background: 'linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01))', border: '1px solid rgba(255,255,255,0.03)' }}>
                  <h2 id="demo-title" style={{ marginTop: 0, color: '#e9fff0', fontSize: '2rem' }}>Demo Video</h2>

                  <div style={{ maxWidth: 880, margin: '14px auto', borderRadius: 12, overflow: 'hidden' }}>
                    {/* Static demo image from public/images/vid.png — fits container responsively */}
                    <div style={{ position: 'relative', width: '100%', paddingBottom: '56.25%' }}>
                      <Image
                        src="/images/vid.png"
                        alt="SurviveX demo thumbnail"
                        fill
                        sizes="(max-width: 640px) 100vw, 880px"
                        style={{ objectFit: 'cover' }}
                      />
                    </div>
                  </div>

                  <p style={{ color: '#cfe9dd', lineHeight: 1.6 }}></p>
      </section>
    </>
  );
}
