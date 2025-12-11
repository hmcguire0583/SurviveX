"use client";

import React, { useState } from "react";

interface ResourceItem {
  title: string;
  filename: string;
}

const ResourceData: ResourceItem[] = [
  {
    title: "Requirements",
    filename: "Requirements.pdf",
  },
  {
    title: "Use Case Diagram",
    filename: "Use Case Diagram.pdf",
  },
  {
    title: "Class Diagram",
    filename: "Class Diagram.pdf",
  },
  {
    title: "Sequence Diagram 1",
    filename: "Buy Item Diagram.pdf",
  },
  {
    title: "Sequence Diagram 2",
    filename: "Island Challenge Diagram.pdf",
  },
  {
    title: "Slides",
    filename: "Slides.pdf",
  },
  {
    title: "SRS",
    filename: "SRS.pdf",
  },
];

const Resource: React.FC = () => {
  const [expanded, setExpanded] = useState<boolean[]>(new Array(ResourceData.length).fill(false));

  const toggleExpand = (index: number) => {
    const newExpanded = [...expanded];
    newExpanded[index] = !newExpanded[index];
    setExpanded(newExpanded);
  };

  return (
    <section
      id="resource"
      className="p-8 max-w-3xl mx-auto"
    >
      <ul className="space-y-4">
        {ResourceData.map((item, index) => (
          <li
            key={index}
            className="[background:rgba(255,255,255,0.02)] rounded-2xl shadow transition overflow-hidden"
          >
            <button
              onClick={() => toggleExpand(index)}
              className="w-full p-4 flex items-center justify-between hover:bg-gray-800 transition text-left"
              style={{ color: "#e9fff0" }}
            >
              <span className="font-semibold">{item.title}</span>
              <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
                style={{
                  transform: expanded[index] ? 'rotate(180deg)' : 'rotate(0deg)',
                  transition: 'transform 200ms ease',
                }}
              >
                <path
                  d="M7 10l5 5 5-5"
                  stroke="#e9fff0"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </button>
            {expanded[index] && (
              <div className="px-4 pb-4 border-t border-gray-700">
                <iframe
                  src={`pdfs/${item.filename}`}
                  width="100%"
                  height="600"
                  style={{ marginTop: 12, border: 'none', borderRadius: 8 }}
                />
              </div>
            )}
          </li>
        ))}
      </ul>
    </section>
  );
};

export default Resource;

