import BackgroundSection from '../../app/components/BackgroundSection';

export const metadata = {
  title: 'Background - SurviveX',
};

export default function BackgroundPage() {
  return (
    <main style={{ background: 'linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%)', color: '#ffffff', minHeight: '100vh', padding: 36 }}>
      <BackgroundSection />
    </main>
  );
}
