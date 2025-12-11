import TeamSection from '../../app/components/TeamSection';

export const metadata = {
  title: 'Team - SurviveX',
};

export default function TeamPage() {
  return (
    <main style={{ background: 'linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%)', color: '#ffffff', minHeight: '100vh', padding: 36 }}>
      <TeamSection />
    </main>
  );
}
