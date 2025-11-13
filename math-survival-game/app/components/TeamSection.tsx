import React from 'react';
import Image from 'next/image';

type Member = {
  name: string;
  role: string;
  blurb: string;
  color?: string;
  github?: string;
  linkedin?: string;
  photo?: string; // filename placed in /public/images/
};

const members: Member[] = [
  {
    name: 'Harry McGuire',
    role: 'Computer Science Major',
    blurb: 'Web Designer',
    color: '#0e766e',
    github: 'https://github.com/hmcguire0583',
    linkedin: 'https://www.linkedin.com/in/harry-mcguire-0595bb301/',
    photo: 'harry-mcguire.jpg'
  },
  {
    name: 'João Ziedins',
    role: 'Computer Science Major',
    blurb: 'Developer',
    color: '#1f6fa1',
    github: 'https://github.com/GhostCinna',
    linkedin: 'https://www.linkedin.com/in/joão-ziedins/',
    photo: 'joao-z.jpg'
  },
  {
    name: 'Max Leavitt',
    role: 'Computer Science Major',
    blurb: 'Developer',
    color: '#7a4ea6',
    github: 'https://github.com/Max-leav',
    linkedin: 'https://www.linkedin.com/in/maxleavitt/',
    photo: 'max-leavitt.jpg'
  },
  {
    name: 'Aryan Bhagat',
    role: 'Computer Science Major',
    blurb: 'Developer',
    color: '#b9624a',
    //github: 'https://github.com/diego-morales',
    linkedin: 'https://www.linkedin.com/in/aryan-bhagat-694799305/',
    photo: 'Aryan-Bhagat.jpg'
  },
  {
    name: 'Praneet Chilla',
    role: 'Computer Science Major',
    blurb: 'Developer',
    color: '#2b8f6b',
    github: 'https://github.com/Kali-Kana',
    linkedin: 'https://www.linkedin.com/in/praneet-chilla-773a02285',
    photo: 'praneet-chilla.jpg'
  }
];

export default function TeamSection() {
  return (
    <section id="team" aria-labelledby="team-title" className="team-section pt-4 -mt-8">
      <h2
        id="team-title"
        className="text-3xl font-extrabold text-[#e9fff0] mx-auto text-center mb-4"
        style={{ textShadow: '0 10px 30px rgba(0,255,127,0.06)' }}
      >
        Meet the Team
      </h2>

      <div className="w-28 h-1 bg-gradient-to-r from-[#00ff7f] to-[#7ef5c6] mx-auto rounded mb-4" aria-hidden />

      <div className="max-w-6xl mx-auto grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Top 3 cards */}
        {members.slice(0, 3).map((m) => (
          <article
            key={m.name}
            className="bg-[rgba(255,255,255,0.02)] p-6 rounded-lg min-h-[300px] flex flex-col items-center text-center"
          >
            <div className="mb-3">
              <div className="text-[#e9fff0] font-bold text-lg">{m.name}</div>
              <div className="text-[#9fb7b0] text-sm">{m.role}</div>
            </div>

            <div
              className="w-48 h-48 rounded-full overflow-hidden bg-gray-200 ring ring-white/95 mb-3"
              style={{ boxShadow: '0 0 18px rgba(255,255,255,0.18)' }}
              aria-hidden
            >
              {m.photo ? (
                m.photo.startsWith('http') ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={m.photo}
                    alt={`${m.name} photo`}
                    className="object-cover w-48 h-48 block rounded-full"
                  />
                ) : (
                  <Image
                    src={`/images/${m.photo}`}
                    alt={`${m.name} photo`}
                    width={192}
                    height={192}
                    sizes="(max-width: 640px) 128px, 192px"
                    quality={90}
                    className="object-cover w-48 h-48 rounded-full"
                    priority={false}
                  />
                )
              ) : (
                <div className="w-48 h-48 rounded-full" style={{ background: m.color }} />
              )}
            </div>

            <p className="text-[#bcd9cf] text-sm mb-3">{m.blurb}</p>

            <div className="flex gap-4 justify-center">
              {m.github && (
                <a
                  href={m.github}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label={`GitHub profile for ${m.name}`}
                  className="text-[#c7dbd4] hover:text-[#e9fff0] text-2xl"
                >
                  <i className="fab fa-github" aria-hidden="true" />
                </a>
              )}
              {m.linkedin && (
                <a
                  href={m.linkedin}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label={`LinkedIn profile for ${m.name}`}
                  className="text-[#c7dbd4] hover:text-[#e9fff0] text-2xl"
                >
                  <i className="fab fa-linkedin" aria-hidden="true" />
                </a>
              )}
            </div>
          </article>
        ))}

        {/* Bottom 2 cards shifted right */}
        <div className="col-span-3 flex justify-center gap-6">
          {members.slice(3).map((m) => (
            <article
              key={m.name}
              className="bg-[rgba(255,255,255,0.02)] p-6 rounded-lg min-h-[300px] flex flex-col items-center text-center w-full sm:w-[calc(50%-12px)] lg:w-[calc(33.333%-12px)]"
            >
              <div className="mb-3">
                <div className="text-[#e9fff0] font-bold text-lg">{m.name}</div>
                <div className="text-[#9fb7b0] text-sm">{m.role}</div>
              </div>

              <div
                className="w-48 h-48 rounded-full overflow-hidden bg-gray-200 ring ring-white/95 mb-3"
                style={{ boxShadow: '0 0 18px rgba(255,255,255,0.18)' }}
                aria-hidden
              >
                {m.photo ? (
                  m.photo.startsWith('http') ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img
                      src={m.photo}
                      alt={`${m.name} photo`}
                      className="object-cover w-48 h-48 block rounded-full"
                    />
                  ) : (
                    <Image
                      src={`/images/${m.photo}`}
                      alt={`${m.name} photo`}
                      width={192}
                      height={192}
                      sizes="(max-width: 640px) 128px, 192px"
                      quality={90}
                      className="object-cover w-48 h-48 rounded-full"
                      priority={false}
                    />
                  )
                ) : (
                  <div className="w-48 h-48 rounded-full" style={{ background: m.color }} />
                )}
              </div>

              <p className="text-[#bcd9cf] text-sm mb-3">{m.blurb}</p>

              <div className="flex gap-4 justify-center">
                {m.github && (
                  <a
                    href={m.github}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label={`GitHub profile for ${m.name}`}
                    className="text-[#c7dbd4] hover:text-[#e9fff0] text-2xl"
                  >
                    <i className="fab fa-github" aria-hidden="true" />
                  </a>
                )}
                {m.linkedin && (
                  <a
                    href={m.linkedin}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label={`LinkedIn profile for ${m.name}`}
                    className="text-[#c7dbd4] hover:text-[#e9fff0] text-2xl"
                  >
                    <i className="fab fa-linkedin" aria-hidden="true" />
                  </a>
                )}
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
