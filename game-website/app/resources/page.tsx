import React from 'react';
import ResourcesSection from '../components/ResourcesSection';

export const metadata = {
  title: 'Bibliography - SurviveX',
};

export default function ResourcePage() {
  return (
    <main style={{ backgroundColor: '#0d0d0d', color: '#f5f5f5', minHeight: '100vh', padding: 36 }}>
      <ResourcesSection />
    </main>
  );
}

