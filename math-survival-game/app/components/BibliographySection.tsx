import React from "react";

interface SourceItem {
  title: string;
  url?: string;
  description?: string;
}

const BibliographyData: SourceItem[] = [
  {
    title: "Common Core State Standards Initiative",
    url: "https://corestandards.org/",
    description:
      "Framework outlining academic benchmarks in mathematics and English language arts used across U.S. schools.",
  },
  {
    title: "Next.js Official Documentation",
    url: "https://nextjs.org/docs",
    description:
      "Official documentation for the Next.js React framework, covering routing, rendering, and deployment.",
  },
  {
    title: "draw.io (diagrams.net) Documentation",
    url: "https://www.diagrams.net/doc/",
    description:
      "Guides for creating UML, class, and sequence diagrams used in the design and documentation process.",
  },
  {
    title: "React Official Documentation",
    url: "https://react.dev/learn",
    description:
      "Core reference for React components, hooks, and state management, used throughout the front-end development process.",
  },
  {
    title: "MDN Web Docs",
    url: "https://developer.mozilla.org/",
    description:
      "Comprehensive resource for HTML, CSS, and JavaScript standards used in styling and interactivity.",
  },
  {
    title: "Game-Based Learning in Mathematics Education (The Massachusetts Department of Education)",
    url: "https://www.doe.mass.edu/frameworks/current.html",
    description:
      "Academic research exploring how interactive games improve motivation and comprehension in mathematics learning.",
  },
  {
    title: "Additional Research Sources",
    description: "More educational and technical sources will be added as the project progresses.",
  },
];

const Bibliography: React.FC = () => {
  return (
    <section id="bibliography" className="p-8 max-w-3xl mx-auto">
      <h2 className="text-2xl font-bold text-[#e9fff0] mb-6">Bibliography</h2>
      <ul className="space-y-4">
        {BibliographyData.map((item, index) => (
          <li
            key={index}
            className="bg-gray-900 p-4 rounded-2xl shadow hover:bg-gray-800 transition"
          >
            {item.url ? (
              <a
                href={item.url}
                target="_blank"
                rel="noopener noreferrer"
                className="font-semibold hover:underline text-[#9fe6b8]"
              >
                {item.title}
              </a>
            ) : (
              <span className="font-semibold text-gray-500">
                {item.title} <em className="text-sm text-gray-400">(Coming Soon)</em>
              </span>
            )}
            {item.description && (
              <p className="text-sm text-gray-400 mt-1">{item.description}</p>
            )}
          </li>
        ))}
      </ul>
    </section>
  );
};

export default Bibliography;
