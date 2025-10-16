import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  images: {
    domains: ["medusa-public-images.s3.eu-west-1.amazonaws.com", "localhost","localhost:9001"],
    remotePatterns: [
      {
        protocol: "http",
        hostname: "localhost",
        port: "9000",
        pathname: "/static/**",
      },
    ],
  },
};

export default nextConfig;
