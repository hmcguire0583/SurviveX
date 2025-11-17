import TeamSection from '../../app/components/TeamSection';

export const metadata = {
  title: 'Team - SurviveX',
};

export default function TeamPage() {
  return (
    <main style={{ backgroundColor: '#0d0d0d', color: '#f5f5f5', minHeight: '100vh', padding: 36 }}>
      <TeamSection />
    </main>
  );
}
