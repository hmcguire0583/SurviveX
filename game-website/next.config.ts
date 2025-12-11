import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async headers() {
    return [
      {
        source: '/downloads/:path*.pck',
        headers: [
          {
            key: 'Content-Type',
            value: 'application/octet-stream',
          },
          {
            key: 'Content-Disposition',
            value: 'attachment',
          },
        ],
      },
    ];
  },
};

export default nextConfig;