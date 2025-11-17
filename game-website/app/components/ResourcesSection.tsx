import React from "react";

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
    filename: "",
  },
  {
    title: "SRS",
    filename: "",
  },
];

const Resource: React.FC = () => {
  return (
    <section
      id="resource"
      className="p-8 max-w-3xl mx-auto"
    >
      <ul className="space-y-4">
        {ResourceData.map((item, index) => (
          <li
            key={index}
            className="bg-gray-900 p-4 rounded-2xl shadow hover:bg-gray-800 transition"
          >
            <a
              href={`pdfs/${item.filename}`}
              target="_blank"
              rel="noopener noreferrer"
              className="font-semibold hover:underline"
              style={{ color: "#e9fff0" }}
            >
               
              {item.title}
            </a>
          </li>
        ))}
      </ul>
    </section>
  );
};

export default Resource;

