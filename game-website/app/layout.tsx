import type { Metadata } from "next";
import { Inter, Russo_One } from "next/font/google";
import "./globals.css";
import Navbar from './components/Navbar';

const inter = Inter({
  variable: "--font-ui",
  subsets: ["latin"],
  weight: ["300", "400", "600", "700"],
  display: "swap",
});

const russo = Russo_One({
  variable: "--font-display",
  subsets: ["latin"],
  weight: "400",
  display: "swap",
});

export const metadata: Metadata = {
  title: "SurviveX",
  description: "SurviveX — a survival math game",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={`${inter.variable} ${russo.variable} antialiased`}>
        {/* Persistent navbar included at root so it remains across pages */}
        <Navbar />
        {children}
      </body>
    </html>
  );
}
