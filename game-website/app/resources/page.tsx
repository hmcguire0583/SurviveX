import React from 'react';
import ResourcesSection from '../components/ResourcesSection';

export const metadata = {
  title: 'Bibliography - SurviveX',
};

export default function ResourcePage() {
  return (
    <main style={{ background: 'linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%)', color: '#ffffff', minHeight: '100vh', padding: 36 }}>
      <ResourcesSection />
    </main>
  );
}

