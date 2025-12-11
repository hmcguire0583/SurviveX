import BibliographySection from '../../app/components/BibliographySection';

export const metadata = {
  title: 'Bibliography - SurviveX',
};

export default function BibliographyPage() {
  return (
    <main style={{ background: 'linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%)', color: '#ffffff', minHeight: '100vh', padding: 36 }}>
      <BibliographySection />
    </main>
  );
}
