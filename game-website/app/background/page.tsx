import BackgroundSection from '../../app/components/BackgroundSection';

export const metadata = {
  title: 'Background - SurviveX',
};

export default function BackgroundPage() {
  return (
    <main style={{ backgroundColor: '#0d0d0d', color: '#f5f5f5', minHeight: '100vh', padding: 36 }}>
      <BackgroundSection />
    </main>
  );
}
