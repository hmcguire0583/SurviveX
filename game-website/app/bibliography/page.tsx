import BibliographySection from '../../app/components/BibliographySection';

export const metadata = {
  title: 'Bibliography - SurviveX',
};

export default function BibliographyPage() {
  return (
    <main style={{ backgroundColor: '#0d0d0d', color: '#f5f5f5', minHeight: '100vh', padding: 36 }}>
      <BibliographySection />
    </main>
  );
}
