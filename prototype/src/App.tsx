import React, { useState, useEffect } from 'react';
import { 
  Compass, 
  Gem, 
  MessageSquare, 
  User, 
  ShieldCheck, 
  Video, 
  Fingerprint, 
  ChevronLeft,
  Lock,
  Zap,
  Calendar,
  CreditCard,
  Briefcase,
  Bell,
  CheckCircle2,
  AlertTriangle,
  Plus,
  Send,
  MoreVertical,
  Camera,
  ImageIcon,
  Award,
  LogOut,
  MapPin,
  X,
  Mic,
  VideoOff,
  PhoneOff,
  Clock,
  BellOff,
  ShieldAlert,
  Share2,
  Shuffle,
  UserPlus,
  Ban
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

// --- Types ---
type Role = 'none' | 'male' | 'female';
type Screen = 'splash' | 'onboarding' | 'paywall' | 'hub' | 'chat' | 'legal' | 'trips' | 'business' | 'profile' | 'business-protocol' | 'video-discovery';
type TripStatus = 'none' | 'proposed' | 'active' | 'completed';

interface UserData {
  id: string;
  name: string;
  age?: number;
  img: string;
  tag?: string;
  location?: string;
  bio?: string;
  role?: 'traveler' | 'gentleman';
  lastMsg?: string;
}

// --- Data ---
const TRAVELERS: UserData[] = [
  { id: 'isabella', name: 'Isabella', age: 24, img: '/assets/isabella.png', tag: 'FOTÓGRAFA', location: 'Santorini, GR', bio: 'Buscando un caballero para compartir un verano eterno en las Cícladas.', lastMsg: '¿Aseguramos Santorini bajo el protocolo?' },
  { id: 'brunna', name: 'Brunna', age: 26, img: '/assets/brunna.png', tag: 'MODELO', location: 'Saint-Tropez, FR', bio: 'Amante del diseño y la navegación privada.', lastMsg: 'El yate está listo para el fin de semana.' },
  { id: 'elena', name: 'Elena', age: 23, img: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150', tag: 'ARTISTA', location: 'Mikonos, GR', lastMsg: 'Te envié la galería de la villa.' }
];

const GENTLEMEN: UserData[] = [
  { id: 'member1', name: 'Marcus Van S.', img: '/assets/member1.png', tag: 'REAL ESTATE', bio: 'Luxury developer focused on Mediterranean resorts.', role: 'gentleman' },
  { id: 'member2', name: 'James L.', img: '/assets/member2.png', tag: 'TECH VC', bio: 'Minimalist investor. Efficient and private.', role: 'gentleman' },
  { id: 'sebastian', name: 'Sebastián K.', img: '/assets/sebastian.png', tag: 'INVERSOR', role: 'gentleman' }
];

// --- Components ---

const FullscreenContainer = ({ children }: { children: React.ReactNode }) => (
  <div className="fixed inset-0 w-screen h-screen bg-black flex flex-col overflow-hidden select-none touch-none z-[9999]">
    {children}
  </div>
);

const Navbar = ({ active, onNav, role }: { active: string, onNav: (s: Screen) => void, role: Role }) => (
  <div className="absolute bottom-8 left-6 right-6 h-[72px] bg-[#0f1116]/90 border border-white/10 rounded-[28px] backdrop-blur-2xl flex items-center justify-around z-50">
    {[
      { id: 'hub', icon: Compass },
      { id: 'trips', icon: Gem },
      { id: 'chat', icon: MessageSquare },
      { id: 'business', icon: Briefcase, hide: role === 'female' },
      { id: 'profile', icon: User }
    ].filter(i => !i.hide).map((item) => (
      <button key={item.id} onClick={() => onNav(item.id as Screen)} className={`p-3 transition-all ${active === item.id ? 'text-primary' : 'text-zinc-600'}`}>
        <item.icon size={24} strokeWidth={active === item.id ? 2.5 : 2} />
      </button>
    ))}
  </div>
);

export default function App() {
  const [role, setRole] = useState<Role>('none');
  const [screen, setScreen] = useState<Screen>('splash');
  const [isSubscribed, setIsSubscribed] = useState(false);
  const [tripStatus, setTripStatus] = useState<TripStatus>('none');
  
  // Navigation State
  const [activeUser, setActiveUser] = useState<UserData | null>(null);
  const [chatMode, setChatMode] = useState<'list' | 'individual'>('list');
  const [isPreviewing, setIsPreviewing] = useState(false);
  const [isCalling, setIsCalling] = useState(false);
  const [showVouchModal, setShowVouchModal] = useState(false);
  const [showNetworkingForm, setShowNetworkingForm] = useState(false);
  const [showChatOptions, setShowChatOptions] = useState(false);
  const [activeOpportunity, setActiveOpportunity] = useState<{title: string, sector: string} | null>(null);
  
  const [message, setMessage] = useState('');
  const [chatMessages, setChatMessages] = useState<Record<string, {sender: Role, text: string}[]>>({});
  const [showAttachMenu, setShowAttachMenu] = useState(false);
  const [discoveryIndex, setDiscoveryIndex] = useState(0);
  const [discoveryState, setDiscoveryState] = useState<'searching' | 'waiting' | 'connected' | 'private'>('searching');

  // Elite Agreement State
  const [customRules, setCustomRules] = useState('1. Horario de oficina (9:00 - 18:00): No molestar.\\n2. Sugerencia: Explorar la ciudad durante mis reuniones.\\n3. Descanso a partir de las 00:00.');
  const [savedProtocols] = useState([
     { id: 'business', name: 'Protocolo Business', rules: 'Reglas enfocadas a viajes de trabajo con discreción total.' },
     { id: 'leisure', name: 'Vacaciones Verano', rules: 'Reglas relajadas para disfrutar del destino.' }
  ]);

  useEffect(() => {
    if (role === 'male' && !isSubscribed) setScreen('paywall');
    else if (role !== 'none' && (screen === 'splash')) setScreen('hub');
  }, [role]);

  const toast = (msg: string, type: 'gold' | 'danger' | 'safe' = 'gold') => {
    const colors = { gold: '#c5a880', danger: '#e94560', safe: '#2ecc71' };
    const event = new CustomEvent('app-toast', { detail: { msg, color: colors[type] } });
    window.dispatchEvent(event);
  };

  const handleOpenChat = (user: UserData) => {
    setActiveUser(user);
    setChatMode('individual');
    setScreen('chat');
    setIsPreviewing(false);
    if (!chatMessages[user.id]) {
        setChatMessages({...chatMessages, [user.id]: [{ sender: 'female', text: `Hola, soy ${user.name}. ${user.lastMsg || '¿En qué puedo ayudarte?'}` }]});
    }
  };

  const handleSendMessage = () => {
    if(!message.trim() || !activeUser) return;
    const userMsgs = chatMessages[activeUser.id] || [];
    setChatMessages({...chatMessages, [activeUser.id]: [...userMsgs, { sender: role, text: message }]});
    setMessage('');
  };

  const renderScreen = () => {
    switch(screen) {
      case 'splash':
        return (
          <div className="w-screen h-screen flex flex-col items-center justify-center bg-black px-6 text-center fade-in">
            <div className="absolute top-8 left-0 right-0 flex justify-center opacity-30">
               <span className="text-[7px] font-black text-primary uppercase tracking-[5px]">NATIVA LIVE 1.2</span>
            </div>
            <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="mb-12">
               <div className="w-24 h-24 bg-primary rounded-[32px] flex items-center justify-center shadow-[0_0_60px_rgba(197,168,128,0.4)] mx-auto"><Gem size={48} className="text-black" /></div>
            </motion.div>
            <h1 className="text-6xl font-black italic tracking-tighter text-white mb-2 leading-none">TripWife</h1>
            <p className="text-[10px] text-primary font-black uppercase tracking-[8px] mb-20 opacity-80">Elite Journey</p>
            
            <div className="w-full space-y-4 pt-12">
               <p className="text-[9px] text-zinc-600 font-bold uppercase tracking-widest mb-6">Selecciona tu perfil de acceso</p>
               <button onClick={() => { setRole('male'); setScreen('onboarding'); }} className="w-full py-5 rounded-[24px] bg-white text-black text-[10px] font-black uppercase tracking-[4px] shadow-xl active:scale-95 transition-all focus:outline-none">
                  Soy un Caballero
               </button>
               <button onClick={() => { setRole('female'); setScreen('onboarding'); }} className="w-full py-5 rounded-[24px] glass border-white/20 text-white text-[10px] font-black uppercase tracking-[4px] active:scale-95 transition-all focus:outline-none">
                  Soy una Viajera
               </button>
            </div>
          </div>
        );

      case 'onboarding':
        return (
          <div className="h-full flex flex-col pt-10 px-8 bg-[#050607] overflow-y-auto pb-20 fade-in">
            <button onClick={() => setScreen('splash')} className="absolute top-6 left-6 w-10 h-10 glass rounded-full flex items-center justify-center text-zinc-400 z-10"><ChevronLeft size={20} /></button>
            <div className="text-center mb-10 pt-4">
              <span className="text-[9px] font-black tracking-[4px] uppercase text-primary mb-2 block object-left">Paso 1 de 2</span>
              <h2 className="text-4xl font-black italic tracking-tighter text-white leading-none">
                {role === 'male' ? 'Validación Ejecutiva' : 'Perfil de Viajera'}
              </h2>
              <p className="text-zinc-500 text-[10px] mt-4 font-bold tracking-widest uppercase">
                {role === 'male' ? 'Requiere Verificación Institucional (KYC)' : 'Comunidad 100% verificada'}
              </p>
            </div>
            
            <div className="space-y-4 mb-10">
              <div className="glass-card bg-black/40 border-white/5 rounded-2xl p-2 flex items-center">
                 <input type="text" placeholder="Alias o Nombre Real" className="w-full bg-transparent border-none text-white px-4 py-3 placeholder:text-zinc-600 outline-none text-sm font-medium" />
              </div>

              {role === 'female' && (
                <>
                  <div className="glass-card bg-black/40 border-white/5 rounded-2xl p-2 flex items-center">
                    <input type="text" placeholder="Ciudad actual (Ej. Miami, FL)" className="w-full bg-transparent border-none text-white px-4 py-3 placeholder:text-zinc-600 outline-none text-sm font-medium" />
                  </div>
                  <div className="glass-card bg-black/40 border-white/5 rounded-2xl p-2 flex items-center">
                    <input type="date" className="w-full bg-transparent border-none text-white px-4 py-3 placeholder:text-zinc-600 outline-none text-sm font-medium opacity-50" />
                  </div>
                </>
              )}

              {role === 'male' && (
                <div className="glass-card p-6 bg-zinc-950 border border-primary/20 rounded-[32px] mt-8 text-center shadow-xl">
                    <ShieldCheck size={32} className="text-primary mx-auto mb-4" />
                    <h3 className="text-sm font-black text-white uppercase tracking-widest mb-2">Escaneo Financiero</h3>
                    <p className="text-[10px] text-zinc-500 leading-relaxed font-bold">En un entorno de producción, esto conectaría con Stripe Identity u Onfido para validación de fondos y antecedentes criminales instantáneos.</p>
                </div>
              )}
            </div>
            
            <div className="mt-auto">
               <button onClick={() => {
                   toast(role === 'male' ? "VALIDACIÓN APROBADA" : "PERFIL CREADO", "gold");
                   setScreen(role === 'male' ? 'paywall' : 'hub');
               }} className="btn-gold w-full flex items-center justify-center py-5 uppercase tracking-[3px] font-black text-sm shadow-primary/30 active:scale-95 transition-all">
                  Completar Registro
               </button>
            </div>
          </div>
        );

      case 'paywall':
        return (
          <div className="h-full px-8 pt-10 overflow-y-auto pb-20 fade-in bg-black">
            <h2 className="text-3xl font-black text-center mb-2 font-display italic tracking-tighter">Privacidad Total</h2>
            <p className="text-zinc-500 text-sm text-center mb-10 font-medium">Validación Platinum obligatoria.</p>
            <div className="glass-card border border-primary/30 p-8 shadow-[0_0_50px_rgba(197,168,128,0.1)]">
              <div className="flex justify-between items-baseline mb-8">
                <div>
                  <span className="text-[10px] font-bold text-primary bg-primary/10 px-3 py-1.5 rounded-md tracking-[3px] uppercase">MEMBRECÍA ANUAL</span>
                  <h3 className="text-4xl font-black text-primary mt-3 italic tracking-tighter">Platinum</h3>
                </div>
                <div className="text-right"><span className="text-2xl font-black">$499</span><span className="text-[10px] text-zinc-500 block font-bold">/mes</span></div>
              </div>
              <ul className="space-y-6 text-sm text-zinc-300 mb-12">
                <li className="flex gap-4 items-center"><div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 border border-primary/20"><ShieldCheck size={16} className="text-primary" /></div> Acceso a Red Cerrada KYC</li>
                <li className="flex gap-4 items-center"><div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 border border-primary/20"><Lock size={16} className="text-primary" /></div> Protocolos de Seguridad Escrow</li>
                <li className="flex gap-4 items-center"><div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 border border-primary/20"><Video size={16} className="text-primary" /></div> Videollamadas Verificadas 24/7</li>
              </ul>
              <button onClick={() => {setIsSubscribed(true); setScreen('hub'); toast("BIENVENIDO AL CLUB PLATINUM", 'gold');}} className="btn-gold w-full flex items-center justify-center gap-3 py-5 text-sm font-black shadow-primary/30 uppercase tracking-[2px]">Activar Cuenta Elite</button>
            </div>
          </div>
        );

      case 'hub':
        return (
          <div className="h-full flex flex-col">
            <header className="px-6 pt-4 flex justify-between items-center mb-2">
              <div><h1 className="text-2xl font-black tracking-tight leading-none italic">Vívelo</h1><p className="text-[8px] text-primary font-bold tracking-[3px] uppercase mt-1 opacity-80">{role === 'male' ? 'PLATINUM FEED' : 'DASHBOARD'}</p></div>
              <div className="flex gap-2">
                 {role === 'male' && (
                    <button onClick={() => { setScreen('video-discovery'); toast("INICIANDO EXPLORACIÓN LIVE", 'gold'); }} className="w-10 h-10 glass rounded-full flex justify-center items-center group active:scale-95 transition-all border-primary/40">
                       <Shuffle size={16} className="text-primary animate-pulse" />
                    </button>
                 )}
                 <button className="w-10 h-10 glass rounded-full flex justify-center items-center group active:scale-95 transition-all"><Bell size={16} className="text-zinc-500 group-hover:text-primary transition-colors" /></button>
                 <button onClick={() => setScreen('profile')} className="w-10 h-10 rounded-full border-2 border-primary overflow-hidden p-[1px] shadow-lg active:scale-95 transition-all"><img src={role === 'male' ? "/assets/sebastian.png" : "/assets/isabella.png"} className="w-full h-full rounded-full object-cover" /></button>
              </div>
            </header>

            <div className="px-6 mb-6">
              {role === 'male' ? (
                 <div onClick={() => setScreen('video-discovery')} className="glass-card bg-gradient-to-r from-primary/20 to-transparent border-primary/30 p-5 rounded-[28px] flex items-center justify-between cursor-pointer group active:scale-[0.98] transition-all">
                    <div className="text-left">
                       <p className="text-[8px] text-primary font-black uppercase tracking-[4px] mb-1">Modo Aburrimiento</p>
                       <h3 className="text-xl font-black text-white italic tracking-tighter">Midnight Live</h3>
                       <p className="text-[10px] text-zinc-500 font-bold mt-1">Videollamadas aleatorias con viajeras live</p>
                    </div>
                    <div className="w-12 h-12 bg-primary/20 rounded-2xl flex items-center justify-center text-primary group-hover:scale-110 transition-transform"><Shuffle size={20} className="animate-spin-slow" /></div>
                 </div>
              ) : (
                 <>
                  <div className="flex justify-between items-center mb-2"><p className="text-[8px] text-zinc-500 font-black uppercase tracking-widest flex items-center gap-1.5"><span className="w-1.5 h-1.5 bg-red-500 rounded-full animate-pulse shadow-[0_0_8px_rgba(239,68,68,0.5)]" /> Live Now</p></div>
                  <div className="flex gap-4 overflow-x-auto pb-2 scrollbar-hide">
                    {TRAVELERS.map((p, idx) => (
                      <div key={idx} className="flex-shrink-0 text-center" onClick={() => {setActiveUser(p); setIsCalling(true);}}>
                        <div className="relative group">
                           <div className="w-[60px] h-[60px] rounded-full p-[2px] border-2 border-primary/40 mb-1 bg-black overflow-hidden relative z-10 group-hover:border-primary transition-all">
                            <img src={p.img} className="w-full h-full rounded-full object-cover grayscale-[0.2] transition-transform group-hover:scale-110" />
                          </div>
                          <span className="absolute bottom-0.5 right-0.5 bg-red-500 text-[6px] font-black px-1.5 py-0.5 rounded-full border border-black z-20 shadow-xl">LIVE</span>
                        </div>
                        <span className="text-[9px] font-bold text-zinc-500 mt-1 block tracking-tight">{p.name.split(' ')[0]}</span>
                      </div>
                    ))}
                  </div>
                 </>
              )}
            </div>

            <div className="flex-1 px-6 overflow-y-auto pb-44 space-y-8">
              {TRAVELERS.map(traveler => (
                <div key={traveler.id} className="glass-card p-0 overflow-hidden relative shadow-2xl border-white/5 active:scale-[0.98] transition-all" onClick={() => { setActiveUser(traveler); setIsPreviewing(true); }}>
                    <img src={traveler.img} className="w-full h-[400px] object-cover" />
                    <div className="absolute inset-0 bg-gradient-to-t from-black via-black/10 to-transparent" />
                    <div className="absolute bottom-8 left-8 right-8 text-left">
                      <div className="flex gap-2 mb-4">
                        <span className="bg-primary/20 text-primary-light text-[9px] font-black px-3 py-1.5 rounded-lg border border-primary/20 uppercase">{traveler.tag}</span>
                        <span className="bg-white/10 text-white text-[9px] font-black px-3 py-1.5 rounded-lg border border-white/10 uppercase tracking-widest">{traveler.location}</span>
                      </div>
                      <h3 className="text-3xl font-black text-white italic tracking-tighter">{traveler.name}, {traveler.age}</h3>
                    </div>
                </div>
              ))}
            </div>
            <Navbar active="hub" role={role} onNav={(s) => setScreen(s)} />


          </div>
        );

      case 'business':
        return (
          <div className="h-full flex flex-col bg-[#050607]">
            <header className="px-6 pt-6 mb-4 flex justify-between items-center text-left">
              <div><h1 className="text-3xl font-black italic tracking-tighter text-left">Networking</h1><p className="text-[10px] text-zinc-500 font-bold tracking-[4px] uppercase mt-2 text-left">Executive Club Directory</p></div>
              <button onClick={() => setShowNetworkingForm(true)} className="w-12 h-12 glass rounded-2xl flex items-center justify-center border-white/5 active:scale-90 transition-all shadow-xl group hover:border-primary/40"><Plus size={24} className="text-primary group-hover:scale-110 transition-transform" /></button>
            </header>
            <div className="flex-1 px-6 space-y-8 overflow-y-auto pb-40 scrollbar-hide pt-2 text-left">
               {/* OPPORTUNITIES FEED */}
               <div className="space-y-4">
                  <h3 className="text-[10px] font-black text-zinc-600 uppercase tracking-widest pl-2 text-left">Oportunidades en la Red</h3>
                  <div className="glass-card bg-primary/5 border-primary/20 p-6 rounded-[36px] shadow-2xl relative overflow-hidden group">
                     <div className="flex justify-between items-start mb-6 text-left">
                        <div className="flex items-center gap-3">
                           <img src="/assets/business_1.png" className="w-10 h-10 rounded-full border border-primary/30 object-cover" />
                           <div className="text-left"><p className="text-xs font-black text-white text-left">Marcus Van S.</p><p className="text-[9px] text-primary/60 font-bold uppercase tracking-widest text-left">Real Estate Inversor</p></div>
                        </div>
                        <div className="px-3 py-1 bg-primary/10 border border-primary/20 rounded-full text-[8px] font-black text-primary uppercase">Mónaco</div>
                     </div>
                     <h4 className="text-lg font-black text-white italic tracking-tighter mb-2 text-left">Luxury Resort Development</h4>
                     <p className="text-[11px] text-zinc-400 leading-relaxed mb-6 italic opacity-80 text-left">"Buscando socio estratégico para expansión en la costa de Mykonos. Proyecto validado y con escrow de seguridad."</p>
                     <button onClick={() => {
                        const marcus = { id: 'marcus', name: 'Marcus Van S.', img: '/assets/business_1.png', tag: 'Business' };
                        setActiveUser(marcus as any);
                        setActiveOpportunity({ title: 'Luxury Resort Development', sector: 'Real Estate' });
                        const newMsgs = { ...chatMessages };
                        if (!newMsgs['marcus']) {
                           newMsgs['marcus'] = [{ sender: role, text: 'Marcus, he visto tu oportunidad sobre "Luxury Resort Development". Me gustaría conocer los detalles.' }];
                           setChatMessages(newMsgs);
                           setTimeout(() => {
                              setChatMessages(prev => ({
                                 ...prev,
                                 'marcus': [...(prev['marcus'] || []), { sender: 'female', text: 'Encantado de saludarte, Sebastián. El proyecto está en fase de preventa con un 15% de ROI proyectado. ¿Quieres revisar el Business Plan?' }]
                              }));
                              toast("MARCUS HA RESPONDIDO", 'gold');
                           }, 2000);
                        }
                        setChatMode('individual');
                        setScreen('chat');
                     }} className="w-full btn-gold py-4 text-[10px] font-black tracking-[4px] uppercase shadow-primary/20 transition-all hover:scale-[1.02] active:scale-95">CONECTAR AHORA</button>
                  </div>
               </div>

               <div className="space-y-4">
                  <h3 className="text-[10px] font-black text-zinc-600 uppercase tracking-widest pl-2 text-left">Directorio de Miembros</h3>
                  {GENTLEMEN.filter(g => g.name !== 'Sebastián K.').map((member) => (
                     <div key={member.id} className="glass-card p-4 bg-zinc-900/10 border-white/5 flex items-center gap-4 rounded-[28px] hover:bg-zinc-900/20 transition-all cursor-pointer" onClick={() => {
                        setActiveUser({ id: member.id, name: member.name, img: member.img, tag: 'Business' } as any);
                        setChatMode('individual');
                        setScreen('chat');
                      }}>
                        <div className="w-14 h-14 rounded-2xl overflow-hidden border border-white/5 grayscale opacity-60"><img src={member.img} className="w-full h-full object-cover" /></div>
                        <div className="flex-1 text-left">
                           <h4 className="text-white font-black text-sm text-left">{member.name}</h4>
                           <p className="text-[9px] text-zinc-600 font-bold uppercase tracking-widest mt-1 mb-2 text-left">{member.tag}</p>
                           <div className="flex items-center gap-2 text-left"><div className="w-1.5 h-1.5 bg-safe rounded-full" /><p className="text-[9px] text-zinc-600 font-bold uppercase italic text-left">Miembro Verificado</p></div>
                        </div>
                        <div className="w-10 h-10 glass rounded-full flex justify-center items-center text-zinc-600"><MessageSquare size={18} /></div>
                     </div>
                  ))}
               </div>

               <div className="p-8 text-center bg-primary/5 rounded-[32px] border border-dashed border-primary/20 mt-10">
                  <Briefcase size={32} className="mx-auto text-primary mb-4 opacity-40" />
                  <p className="text-xs text-zinc-500 font-bold uppercase tracking-widest leading-relaxed">Solo los miembros Platinum pueden acceder al directorio completo de inversionistas.</p>
               </div>
            </div>
            <Navbar active="business" role={role} onNav={(s) => setScreen(s)} />

            {/* NEW OPPORTUNITY FORM */}
            <AnimatePresence>
               {showNetworkingForm && (
                  <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="absolute inset-0 z-[200] bg-black/95 backdrop-blur-xl flex items-center justify-center px-8">
                     <div className="w-full glass-card p-10 rounded-[44px] border-primary/20 relative">
                        <button onClick={() => setShowNetworkingForm(false)} className="absolute top-8 right-8 text-zinc-600 hover:text-white transition-colors"><X size={24} /></button>
                        <div className="text-center mb-10">
                           <Briefcase size={40} className="mx-auto text-primary mb-4" />
                           <h3 className="text-2xl font-black italic text-white tracking-tighter">Nueva Oportunidad</h3>
                           <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-[4px] mt-2">Broadcast to Elite Members</p>
                        </div>
                        
                        <div className="space-y-6 mb-12 text-left">
                           <div className="space-y-2 text-left">
                              <label className="text-[8px] font-black text-zinc-500 uppercase tracking-widest ml-1 text-left">Sector / Industria</label>
                              <select className="w-full bg-black/40 border border-white/5 rounded-2xl px-5 py-4 text-xs text-white outline-none focus:border-primary/40 appearance-none italic text-left">
                                 <option>Real Estate & Development</option>
                                 <option>Tech VC & Startups</option>
                                 <option>Private Equity</option>
                                 <option>Art & Collectibles</option>
                              </select>
                           </div>
                           <div className="space-y-2 text-left">
                              <label className="text-[8px] font-black text-zinc-500 uppercase tracking-widest ml-1 text-left">Descripción Breve</label>
                              <textarea className="w-full h-32 bg-black/40 border border-white/5 rounded-2xl p-5 text-xs text-zinc-300 outline-none focus:border-primary/40 resize-none italic text-left" placeholder="Describe tu propuesta de valor..."></textarea>
                           </div>
                        </div>

                        <button onClick={() => { setShowNetworkingForm(false); toast("OPORTUNIDAD PUBLICADA", 'gold'); }} className="btn-gold w-full py-5 text-sm font-black tracking-[4px] uppercase shadow-primary/30">Lanzar Propuesta</button>
                     </div>
                  </motion.div>
               )}
            </AnimatePresence>
          </div>
        );

      case 'chat':
        return chatMode === 'list' ? (
          <div className="h-full flex flex-col">
            <header className="px-6 pt-6 mb-8 text-left"><h1 className="text-3xl font-black italic tracking-tighter text-left">Mensajes</h1><p className="text-[10px] text-primary font-bold tracking-[4px] uppercase mt-2 text-left">Encrypted Conversations</p></header>
             <div className="flex-1 px-6 space-y-4 overflow-y-auto pb-44 scrollbar-hide pt-2 text-left">
                {/* BUSINESS CHATS INTEGRATED */}
                <div key="james-biz" onClick={() => handleOpenChat({ id: 'james', name: 'James L.', img: '/assets/business_2.png', tag: 'Business' } as any)} className="glass-card p-5 bg-primary/5 border-primary/20 flex items-center gap-5 active:scale-[0.98] transition-all relative overflow-hidden group">
                   <div className="absolute top-0 right-0 w-16 h-16 bg-primary/5 rounded-bl-full -mr-4 -mt-4 transition-transform group-hover:scale-110" />
                   <div className="relative">
                      <img src="/assets/business_2.png" className="w-16 h-16 rounded-full object-cover border-2 border-primary/30 p-1" />
                      <div className="absolute -top-1 -right-1 px-2 py-0.5 bg-primary text-[8px] font-black text-black rounded-full uppercase tracking-widest shadow-xl">Business</div>
                   </div>
                   <div className="flex-1 min-w-0 text-left">
                      <div className="flex justify-between items-baseline mb-1 text-left">
                         <h4 className="text-white font-black text-sm text-left">James L. (Inversionista)</h4>
                         <span className="text-[9px] text-primary font-black uppercase">Online</span>
                      </div>
                      <p className="text-xs text-primary/70 truncate font-black italic text-left">"Confirmado el meeting en el Jet privado."</p>
                   </div>
                </div>

                {TRAVELERS.map((traveler) => (
                   <div key={traveler.id} onClick={() => handleOpenChat(traveler)} className="glass-card p-5 bg-zinc-900/10 border-white/5 flex items-center gap-5 active:scale-[0.98] transition-all">
                      <div className="relative">
                         <img src={traveler.img} className="w-16 h-16 rounded-full object-cover border-2 border-primary/20" />
                         <div className="absolute bottom-1 right-1 w-4 h-4 bg-safe border-4 border-black rounded-full" />
                      </div>
                      <div className="flex-1 min-w-0 text-left">
                         <div className="flex justify-between items-baseline mb-1 text-left">
                            <h4 className="text-white font-black text-sm text-left">{traveler.name}</h4>
                            <span className="text-[9px] text-zinc-600 font-bold">12:34 PM</span>
                         </div>
                         <p className="text-xs text-zinc-500 truncate font-medium text-left">{chatMessages[traveler.id]?.[chatMessages[traveler.id].length-1]?.text || traveler.lastMsg}</p>
                      </div>
                   </div>
                ))}
            </div>
            <Navbar active="chat" role={role} onNav={(s) => setScreen(s)} />
          </div>
        ) : (
          <div className="h-full flex flex-col pt-4">
            <header className="px-6 py-4 flex items-center justify-between border-b border-white/5 bg-black/40 backdrop-blur-xl z-[60] relative text-left">
              <div className="flex items-center gap-4 text-left">
                <button onClick={() => setChatMode('list')} className="text-zinc-500"><ChevronLeft size={24} /></button>
                <div className="relative border-2 border-primary/30 p-[2px] rounded-full cursor-pointer" onClick={() => setIsPreviewing(true)}>
                  <img src={activeUser?.img} className="w-10 h-10 rounded-full object-cover" />
                  <div className="absolute -bottom-0.5 -right-0.5 w-3 h-3 bg-green-500 rounded-full border-2 border-black" />
                </div>
                <div className="text-left"><h3 className="text-sm font-black text-white text-left">{activeUser?.name}</h3><p className={`text-[10px] font-black uppercase tracking-widest mt-0.5 italic text-primary text-left`}>{activeUser?.tag === 'Business' ? 'Business Partner' : 'Verified Traveler'}</p></div>
              </div>
               <div className="flex items-center gap-2">
                  <button onClick={() => setIsCalling(true)} className="w-10 h-10 glass rounded-full flex justify-center items-center text-primary border-primary/20 shadow-lg active:scale-95 transition-all"><Video size={18} /></button>
                  <button onClick={() => setShowChatOptions(!showChatOptions)} className="w-10 h-10 glass rounded-full flex justify-center items-center text-zinc-500 border-white/5 active:scale-95 transition-all relative"><MoreVertical size={18} /></button>
               </div>

              <AnimatePresence>
                {showChatOptions && (
                  <motion.div initial={{ opacity: 0, y: 10, scale: 0.95 }} animate={{ opacity: 1, y: 0, scale: 1 }} exit={{ opacity: 0, y: 10, scale: 0.95 }} className="absolute top-20 right-6 w-56 bg-[#0f1116] border border-white/10 rounded-[28px] p-4 shadow-[0_20px_50px_rgba(0,0,0,0.9)] z-[100] overflow-hidden">
                    <div className="space-y-1">
                      <button className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl hover:bg-white/5 transition-colors group text-left" onClick={() => { setShowChatOptions(false); setIsPreviewing(true); }}>
                        <User size={16} className="text-zinc-500 group-hover:text-primary" />
                        <span className="text-[10px] font-black text-zinc-400 uppercase tracking-widest group-hover:text-white">Ver Perfil</span>
                      </button>
                      <button className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl hover:bg-white/5 transition-colors group text-left" onClick={() => { setShowChatOptions(false); toast("AUTO-DESTRUCCIÓN ACTIVADA", 'gold'); }}>
                        <Clock size={16} className="text-zinc-500 group-hover:text-primary" />
                        <span className="text-[10px] font-black text-zinc-400 uppercase tracking-widest group-hover:text-white">Auto-destruir</span>
                      </button>
                      <button className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl hover:bg-white/5 transition-colors group text-left" onClick={() => { setShowChatOptions(false); toast("NOTIFICACIONES SILENCIADAS", 'gold'); }}>
                        <BellOff size={16} className="text-zinc-500 group-hover:text-primary" />
                        <span className="text-[10px] font-black text-zinc-400 uppercase tracking-widest group-hover:text-white">Silenciar</span>
                      </button>
                      <div className="h-[1px] bg-white/5 my-2 mx-4" />
                      <button className="w-full flex items-center gap-3 px-4 py-3 rounded-2xl hover:bg-red-500/10 transition-colors group text-left" onClick={() => { setShowChatOptions(false); setChatMode('list'); toast("PERSONA BLOQUEADA", 'gold'); }}>
                        <ShieldAlert size={16} className="text-red-500/50 group-hover:text-red-500" />
                        <span className="text-[10px] font-black text-red-500/50 uppercase tracking-widest group-hover:text-red-500">Bloquear</span>
                      </button>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </header>

            <div className="flex-1 px-6 py-4 overflow-y-auto flex flex-col gap-5 scrollbar-hide relative pt-6 text-left">
               {activeOpportunity && (
                  <motion.div initial={{ y: -20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} className="mb-4 bg-primary/5 border border-primary/20 rounded-[28px] p-4 flex items-center justify-between shadow-xl">
                     <div className="flex items-center gap-4 text-left">
                        <div className="w-10 h-10 bg-primary/20 rounded-xl flex items-center justify-center text-primary"><Briefcase size={20} /></div>
                        <div className="text-left">
                           <p className="text-[8px] font-black text-primary uppercase tracking-[2px] text-left">Contexto de Negocio</p>
                           <h5 className="text-[11px] font-black text-white italic text-left">{activeOpportunity.title}</h5>
                        </div>
                     </div>
                     <div className="flex items-center gap-2">
                        <button onClick={() => toast("DESCARGANDO PROYECTO.PDF", "gold")} className="p-2 glass rounded-xl text-primary"><CreditCard size={14} /></button>
                        <button onClick={() => setActiveOpportunity(null)} className="text-zinc-600 hover:text-white"><X size={16} /></button>
                     </div>
                  </motion.div>
               )}

              {(chatMessages[activeUser?.id || ''] || []).map((msg, idx) => (
                <div key={idx} className={`p-5 rounded-[28px] text-sm max-w-[85%] border shadow-xl leading-relaxed text-left ${msg.sender === role ? 'self-end bg-primary/10 border-primary/20 rounded-tr-none text-zinc-200' : 'self-start bg-zinc-900/40 border-white/5 rounded-tl-none text-zinc-300'}`}>
                  {msg.text}
                </div>
              ))}
              
              {activeUser?.tag === 'Business' ? (
                  <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="glass border-primary border-2 p-8 rounded-[36px] text-center my-6 relative overflow-hidden self-center w-full shadow-[0_0_50px_rgba(197,168,128,0.2)] bg-gradient-to-b from-primary/10 to-transparent">
                     <ShieldCheck size={40} className="mx-auto text-primary mb-6" />
                     <h4 className="text-primary font-black text-xs mb-3 uppercase tracking-[4px]">Partnership Agreement</h4>
                     <p className="text-[11px] text-zinc-400 mb-8 font-medium">Contrato de Alianza Comercial · $100k+ Escrow Capable</p>
                     <button onClick={() => setScreen('business-protocol')} className="btn-gold w-full py-4 text-sm tracking-[3px] uppercase font-black shadow-primary/40 text-black">Cerrar Alianza</button>
                  </motion.div>
               ) : tripStatus === 'proposed' && (
                  <motion.div initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} className="glass border-primary border-2 p-8 rounded-[36px] text-center my-6 relative overflow-hidden self-center w-full shadow-[0_0_50px_rgba(197,168,128,0.2)]">
                     <Fingerprint size={40} className="mx-auto text-primary mb-6" />
                     <h4 className="text-primary font-black text-xs mb-3 uppercase tracking-[4px]">Protocolo Legal</h4>
                     <p className="text-[11px] text-zinc-400 mb-8 font-medium">Fondo de $2,500 en custodia.</p>
                     {role === 'female' ? <button onClick={() => setScreen('legal')} className="btn-gold w-full py-4 text-sm tracking-[3px] uppercase font-black shadow-primary/40">ACTIVAR</button> : <div className="text-[9px] text-zinc-600 uppercase font-black tracking-widest text-center">Esperando Respuesta...</div>}
                  </motion.div>
               )}

              <AnimatePresence>
                {showAttachMenu && (
                  <motion.div initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} exit={{ y: 20, opacity: 0 }} className="absolute bottom-4 left-0 right-0 z-50 px-4">
                    <div className="glass p-6 rounded-[32px] flex justify-around border-primary/30 shadow-[0_20px_50px_rgba(0,0,0,0.5)] backdrop-blur-3xl">
                      <button className="flex flex-col items-center gap-3 group" onClick={() => {if(role==='male') setScreen('legal'); setShowAttachMenu(false);}}>
                         <div className="w-14 h-14 bg-primary/10 rounded-2xl flex items-center justify-center text-primary border border-primary/20 group-hover:bg-primary/20 transition-all"><ShieldCheck size={24} /></div>
                         <span className="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Protocolo</span>
                      </button>
                      <button className="flex flex-col items-center gap-3 group" onClick={() => setShowAttachMenu(false)}>
                         <div className="w-14 h-14 bg-zinc-900 rounded-2xl flex items-center justify-center text-zinc-400 border border-white/5 group-hover:bg-zinc-800 transition-all"><ImageIcon size={24} /></div>
                         <span className="text-[10px] font-black text-zinc-500 uppercase tracking-widest">Galería</span>
                      </button>
                      <button className="flex flex-col items-center gap-3 group" onClick={() => setShowAttachMenu(false)}>
                         <div className="w-14 h-14 bg-zinc-900 rounded-2xl flex items-center justify-center text-zinc-400 border border-white/5 group-hover:bg-zinc-800 transition-all"><Camera size={24} /></div>
                         <span className="text-[10px] font-black text-zinc-500 uppercase tracking-widest">Foto</span>
                      </button>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>

            <div className="p-5 pb-10 bg-black/80 border-t border-white/5 relative z-10 text-left">
              <div className="flex items-center gap-4 text-left">
                 <button onClick={() => setShowAttachMenu(!showAttachMenu)} className={`w-14 h-14 rounded-2xl flex justify-center items-center transition-all ${showAttachMenu ? 'bg-primary text-black scale-110' : 'bg-[#121212] text-zinc-400 border border-white/10'}`}><Plus size={28} /></button>
                 <div className="flex-1 bg-[#121212] border border-white/10 rounded-2xl flex items-center px-5 h-14 pb-0.5 shadow-inner text-left">
                   <input type="text" value={message} onChange={(e) => setMessage(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()} placeholder="Mensaje privado..." className="bg-transparent border-none outline-none text-sm w-full placeholder:text-zinc-600 font-medium text-left" />
                   <button onClick={handleSendMessage} className={`transition-all ${message.trim() ? 'text-primary' : 'text-zinc-700'}`}><Send size={22} /></button>
                 </div>
              </div>
            </div>
          </div>
        );

      case 'profile':
        return (
          <div className="h-full flex flex-col bg-black">
            <header className="px-6 pt-6 flex justify-between items-center mb-2 text-left"><h1 className="text-3xl font-black italic tracking-tighter text-left">Perfil Elite</h1><button onClick={() => setRole('none')} className="w-11 h-11 glass rounded-full flex justify-center items-center text-red-500 border-red-500/10"><LogOut size={20} /></button></header>
            <div className="flex-1 px-8 overflow-y-auto pb-56 scrollbar-hide pt-4 text-center">
               <div className="flex flex-col items-center mb-10 relative mt-4">
                  <div className="relative mb-6">
                    <div className="absolute -inset-6 rounded-full border-[2px] border-primary animate-pulse opacity-20" />
                    <div className="absolute -inset-2 rounded-full border-[2px] border-primary shadow-[0_0_40px_rgba(197,168,128,0.4)]" />
                    <img src={role === 'male' ? "/assets/sebastian.png" : "/assets/isabella.png"} className="w-36 h-36 rounded-full border-4 border-black object-cover relative z-10" />
                    <div className="absolute -bottom-2 right-2 bg-primary text-black p-2 rounded-full border-[6px] border-black z-20 shadow-2xl"><ShieldCheck size={24} strokeWidth={3} /></div>
                  </div>
                  <h2 className="text-3xl font-black text-white tracking-tight">{role === 'male' ? 'Sebastián Keresztesy' : 'Isabella Rossi'}</h2>
                  <p className="text-[10px] text-primary font-black uppercase tracking-[6px] mt-3 mb-6 bg-primary/5 px-4 py-1.5 rounded-full border border-primary/20">PREMIUM MEMBER #0049</p>
                  <div className="flex gap-3">
                     <div className="flex flex-col items-center gap-1"><div className="w-10 h-10 glass rounded-xl flex items-center justify-center text-primary"><Award size={20} /></div><span className="text-[7px] font-black text-zinc-500 uppercase tracking-widest">Honor</span></div>
                     <div className="flex flex-col items-center gap-1"><div className="w-10 h-10 glass rounded-xl flex items-center justify-center text-primary"><ShieldCheck size={20} /></div><span className="text-[7px] font-black text-zinc-500 uppercase tracking-widest">Discreción</span></div>
                     <div className="flex flex-col items-center gap-1"><div className="w-10 h-10 glass rounded-xl flex items-center justify-center text-primary"><Zap size={20} /></div><span className="text-[7px] font-black text-zinc-500 uppercase tracking-widest">Vouching</span></div>
                  </div>
               </div>

               <div className="space-y-6 text-left">
                  <h3 className="text-[10px] font-black text-zinc-600 uppercase tracking-widest pl-2 text-left">Reputación en la Red</h3>
                  <div className="glass-card bg-[#0a0b0d] p-7 rounded-[36px] border-white/5 relative overflow-hidden text-left">
                     <div className="flex items-center justify-between mb-8 text-left">
                        <div className="text-left"><p className="text-2xl font-black text-white text-left">Platinum Elite</p><p className="text-[10px] text-primary font-bold uppercase tracking-[3px] mt-1 text-left">Estatus de Confianza</p></div>
                        <div className="w-14 h-14 bg-primary/10 rounded-2xl flex items-center justify-center border border-primary/20 text-primary"><Gem size={28} /></div>
                     </div>
                     <div className="space-y-4">
                        <div className="flex justify-between items-center text-left"><span className="text-[10px] font-black text-zinc-500 uppercase tracking-widest text-left">Avales de Miembros</span><span className="text-xs font-black text-white">12 Avales</span></div>
                        <div className="w-full h-1.5 bg-zinc-900 rounded-full overflow-hidden"><motion.div initial={{ width: 0 }} animate={{ width: '85%' }} className="h-full bg-primary shadow-[0_0_10px_rgba(197,168,128,0.5)]" /></div>
                     </div>
                  </div>
               </div>
            </div>
            <Navbar active="profile" role={role} onNav={(s) => setScreen(s)} />
          </div>
        );

      case 'legal':
        return (
          <div className="h-full flex flex-col pt-4 bg-[#050607]">
            <header className="px-6 py-4 flex items-center justify-between text-left">
               <button onClick={() => setScreen('chat')} className="w-10 h-10 glass rounded-full flex items-center justify-center"><ChevronLeft size={20} /></button>
               <h2 className="text-sm font-black uppercase tracking-[4px] text-primary text-center w-full">Contrato de Estancia</h2>
               <div className="w-10" />
            </header>

            <div className="flex-1 px-8 overflow-y-auto pb-10 scrollbar-hide text-center">
              <div className="mb-10 text-center">
                 <p className="text-[10px] text-zinc-500 font-bold uppercase tracking-[4px] mb-2 text-center">Protocolo de Escrow Activo</p>
                 <h3 className="text-5xl font-black text-white italic tracking-tighter text-center">$2,500</h3>
              </div>

              <div className="mb-10 text-left">
                 <p className="text-[10px] font-black text-zinc-600 uppercase tracking-widest mb-4 ml-1 text-left">Mis Plantillas Guardadas</p>
                 <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide text-left">
                    {savedProtocols.map(p => (
                       <button key={p.id} onClick={() => setCustomRules(p.rules)} className="flex-shrink-0 px-5 py-3 glass rounded-2xl border-white/5 text-[10px] font-black text-zinc-400 uppercase tracking-widest hover:border-primary/40 transition-all font-display">{p.name}</button>
                    ))}
                    <button className="flex-shrink-0 w-10 h-10 glass rounded-2xl flex items-center justify-center border-dashed border-white/10 text-zinc-600"><Plus size={18} /></button>
                 </div>
              </div>
              
              <div className="glass-card mb-8 border-primary/20 bg-zinc-950 p-8 rounded-[36px] shadow-2xl relative overflow-hidden text-left">
                <div className="flex items-center gap-3 mb-6 text-left">
                   <Lock size={16} className="text-primary" />
                   <p className="text-[10px] text-primary font-black uppercase tracking-[3px] text-left">Términos de Convivencia</p>
                </div>
                
                <div className="space-y-6 text-left">
                   <div className="text-left">
                      <label className="text-[9px] font-black text-zinc-500 uppercase tracking-widest block mb-3 ml-1 text-left">Reglas Personalizadas</label>
                      <textarea 
                        value={customRules}
                        onChange={(e) => setCustomRules(e.target.value)}
                        className="w-full h-44 bg-black/40 border border-white/5 rounded-2xl p-5 text-[12px] text-zinc-300 font-medium leading-relaxed outline-none focus:border-primary/40 transition-all resize-none italic text-left"
                        placeholder="Define tus reglas aquí..."
                      />
                   </div>
                </div>

                <div className="mt-8 pt-8 border-t border-white/5 flex items-center gap-4 text-left">
                   <div className="w-12 h-12 rounded-2xl bg-safe/10 flex items-center justify-center text-safe"><ShieldCheck size={24} /></div>
                   <div className="flex-1 text-left">
                      <p className="text-[11px] font-black text-white uppercase text-left">Aceptación Mutua</p>
                      <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest mt-0.5 text-left">Firmado digitalmente por TripWife</p>
                   </div>
                </div>
              </div>

              <div className="h-32 bg-zinc-900/50 border-2 border-dashed border-primary/20 rounded-[40px] flex items-center justify-center flex-col gap-3 cursor-pointer hover:bg-primary/5 transition-all shadow-inner group" onClick={() => { toast("PROTOCOLO ACTUALIZADO", 'gold'); }}>
                <Fingerprint size={32} className="text-primary opacity-50 group-hover:opacity-100 transition-opacity" />
                <p className="text-[8px] text-zinc-600 font-black uppercase tracking-[5px] text-center">Validar & Guardar Plantilla</p>
              </div>
            </div>

            <div className="p-8 pb-12 pt-0 text-center">
               <button onClick={() => {
                 if(role === 'male') setTripStatus('proposed'); 
                 else setTripStatus('active'); 
                 setScreen('chat');
                 toast("ACUERDO ENVIADO", 'gold');
               }} className="btn-gold w-full text-sm font-black tracking-[4px] py-6 shadow-primary/40 uppercase shadow-2xl">ENVIAR A VALIDACIÓN</button>
            </div>
          </div>
        );

      case 'business-protocol':
        return (
          <div className="h-full flex flex-col pt-4 bg-[#050607]">
            <header className="px-6 py-4 flex items-center justify-between text-left">
               <button onClick={() => setScreen('chat')} className="w-10 h-10 glass rounded-full flex items-center justify-center"><ChevronLeft size={20} /></button>
               <h2 className="text-sm font-black uppercase tracking-[4px] text-primary text-center w-full">Protocolo de Sociedad</h2>
               <div className="w-10" />
            </header>

            <div className="flex-1 px-8 overflow-y-auto pb-10 scrollbar-hide text-left">
               <div className="mb-10 text-center">
                  <p className="text-[10px] text-zinc-500 font-bold uppercase tracking-[4px] mb-2 text-center">Marco de inversión Protegida</p>
                  <h3 className="text-4xl font-black text-white italic tracking-tighter text-center">Elite Partnership</h3>
               </div>

               <div className="space-y-6">
                  <div className="glass-card p-6 border-primary/20 bg-zinc-950 rounded-[32px] shadow-xl">
                     <div className="flex items-center gap-4 mb-4">
                        <div className="w-12 h-12 bg-primary/10 rounded-2xl flex items-center justify-center text-primary"><ShieldCheck size={24} /></div>
                        <div className="text-left">
                           <h4 className="text-xs font-black text-white uppercase tracking-widest text-left">1. Validación Blindada</h4>
                           <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest mt-1 text-left">KYC institucional y verificación de fondos</p>
                        </div>
                     </div>
                  </div>

                  <div className="glass-card p-6 border-white/5 bg-zinc-950 rounded-[32px] shadow-xl opacity-80">
                     <div className="flex items-center gap-4 mb-4">
                        <div className="w-12 h-12 bg-zinc-900 rounded-2xl flex items-center justify-center text-zinc-500"><CreditCard size={24} /></div>
                        <div className="text-left">
                           <h4 className="text-xs font-black text-white uppercase tracking-widest text-left">2. Smart Escrow</h4>
                           <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest mt-1 text-left">Custodia de fondos para capital seed o inversión</p>
                        </div>
                     </div>
                  </div>

                  <div className="glass-card p-6 border-white/5 bg-zinc-950 rounded-[32px] shadow-xl opacity-80">
                     <div className="flex items-center gap-4 mb-4">
                        <div className="w-12 h-12 bg-zinc-900 rounded-2xl flex items-center justify-center text-zinc-500"><Lock size={24} /></div>
                        <div className="text-left">
                           <h4 className="text-xs font-black text-white uppercase tracking-widest text-left">3. NDA On-Chain</h4>
                           <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest mt-1 text-left">Acuerdo de confidencialidad encriptado</p>
                        </div>
                     </div>
                  </div>
               </div>

               <div className="mt-10 p-8 bg-primary/5 rounded-[40px] border border-dashed border-primary/20 text-center">
                  <p className="text-[11px] text-zinc-400 leading-relaxed font-bold italic">
                     "Este protocolo asegura que cada socio estratégico de la red TripWife cumple con los estándares más altos de solvencia y discreción ejecutiva."
                  </p>
               </div>
            </div>

            <div className="p-8 pb-12 pt-0 text-center">
               <button onClick={() => { toast("SOLICITUD DE SOCIEDAD ENVIADA", 'gold'); setScreen('chat'); }} className="btn-gold w-full text-sm font-black tracking-[4px] py-6 shadow-primary/40 uppercase">INICIAR VALIDACIÓN</button>
            </div>
          </div>
        );

      case 'video-discovery':
        const currentLive = TRAVELERS[discoveryIndex];
        return (
          <div className="h-full bg-black flex flex-col relative overflow-hidden">
            {/* BACKGROUND VIDEO (Placeholder image) */}
            <AnimatePresence mode="wait">
              <motion.img 
                key={currentLive.id} 
                src={currentLive.img} 
                initial={{ opacity: 0, scale: 1.1 }} 
                animate={{ opacity: 1, scale: 1 }} 
                exit={{ opacity: 0, filter: 'blur(20px)' }}
                className="absolute inset-0 w-full h-full object-cover filter brightness-[0.7] grayscale-[0.1]" 
              />
            </AnimatePresence>
            
            {/* OVERLAY GRADIENTS */}
            <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-black/60" />
            <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-transparent to-transparent" />
            
            {/* TOP INFO */}
            <div className="absolute top-12 left-8 right-8 flex justify-between items-center z-10">
               <button onClick={() => {setScreen('hub'); setDiscoveryState('searching');}} className="w-10 h-10 glass rounded-full flex items-center justify-center text-white/80 active:scale-90 transition-all"><ChevronLeft /></button>
               <div className="px-5 py-2 glass rounded-full flex items-center gap-3 border-red-500/30 shadow-[0_0_20px_rgba(239,68,68,0.2)]">
                  <div className="w-2.5 h-2.5 bg-red-500 rounded-full animate-pulse shadow-[0_0_10px_rgba(239,68,68,0.8)]" />
                  <span className="text-[11px] font-black text-white uppercase tracking-[4px] italic">Elite en Vivo</span>
               </div>
               <div className="w-10" />
            </div>

            {/* BLOCK BUTTON */}
            {discoveryState !== 'private' && (
               <div className="absolute top-28 right-8 z-10">
                  <button onClick={() => {toast("USUARIO BLOQUEADO", "danger"); setDiscoveryIndex((prev) => (prev + 1) % TRAVELERS.length); setDiscoveryState('searching');}} className="w-10 h-10 glass rounded-full flex items-center justify-center text-zinc-600 hover:text-danger hover:border-danger/30 transition-all">
                     <Ban size={16} />
                  </button>
               </div>
            )}

            {/* BOTTOM CONTROLS */}
            <div className="absolute inset-x-0 bottom-12 px-8 flex flex-col gap-6 z-10">
               <motion.div initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} key={currentLive.id + '_txt'} className="text-left mb-4">
                  <div className="flex items-center gap-2 mb-2">
                     <span className="bg-primary/20 text-primary text-[8px] font-black px-2.5 py-1 rounded-lg border border-primary/20 uppercase tracking-[2px]">{currentLive.tag}</span>
                  </div>
                  <h3 className="text-4xl font-black text-white italic tracking-tighter leading-none">{currentLive.name}, {currentLive.age}</h3>
                  <p className="text-zinc-400 text-[11px] font-bold uppercase tracking-[3px] mt-2 italic flex items-center gap-2 opacity-80"><MapPin size={12} className="text-primary/60" /> {currentLive.location}</p>
               </motion.div>
               
               <div className="flex gap-4">
                  {discoveryState === 'searching' && (
                     <>
                        <button onClick={() => { 
                           setDiscoveryState('waiting'); 
                           toast("INVITACIÓN ENVIADA", 'gold');
                           setTimeout(() => {
                              setDiscoveryState('connected');
                              toast(`${currentLive.name.toUpperCase()} HA ACEPTADO`, 'safe');
                           }, 2000);
                        }} className="h-16 flex-1 glass rounded-[28px] flex items-center justify-center gap-3 text-[10px] font-black uppercase tracking-[4px] text-white hover:bg-white/10 transition-all border-white/10 active:scale-95 shadow-2xl">
                           <UserPlus size={20} className="text-primary" />
                           CONECTAR
                        </button>
                        <button onClick={() => { setDiscoveryIndex((prev) => (prev + 1) % TRAVELERS.length); setDiscoveryState('searching'); toast("SIGUIENTE CONEXIÓN...", 'gold'); }} className="h-16 w-32 btn-gold rounded-[28px] flex items-center justify-center transition-all active:scale-95 group shadow-[0_10px_30px_rgba(197,168,128,0.3)]">
                           <Shuffle size={24} strokeWidth={3} className="group-hover:rotate-180 transition-transform duration-500" />
                        </button>
                     </>
                  )}
                  
                  {discoveryState === 'waiting' && (
                     <button className="h-16 flex-1 glass rounded-[28px] flex items-center justify-center gap-4 text-[10px] font-black uppercase tracking-[3px] text-zinc-400 border-white/5 cursor-wait">
                        <div className="w-5 h-5 border-2 border-primary border-t-transparent rounded-full animate-spin" />
                        Esperando respuesta...
                     </button>
                  )}

                  {discoveryState === 'connected' && (
                     <div className="w-full space-y-3">
                        <div className="h-14 w-full bg-safe/10 border border-safe/30 rounded-2xl flex items-center justify-center gap-3 text-safe text-[9px] font-black uppercase tracking-[3px]">
                           <CheckCircle2 size={16} /> Contacto Establecido
                        </div>
                        <button onClick={() => { 
                           setDiscoveryState('private'); 
                           toast("MODO PRIVADO ACTIVADO", "gold");
                        }} className="btn-gold h-16 w-full rounded-[28px] flex items-center justify-center gap-3 text-sm font-black uppercase tracking-[4px] shadow-[0_15px_40px_rgba(197,168,128,0.4)] active:scale-95 transition-all">
                           <Lock size={20} />
                           PASAR A PRIVADO
                        </button>
                     </div>
                  )}

                  {discoveryState === 'private' && (
                     <div className="w-full space-y-6">
                        <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="glass p-6 rounded-[32px] border-primary/40 bg-primary/5 backdrop-blur-3xl shadow-[0_0_50px_rgba(197,168,128,0.2)]">
                           <div className="flex items-center gap-4 mb-4">
                              <div className="w-12 h-12 bg-primary/20 rounded-2xl flex items-center justify-center text-primary"><Lock size={24} /></div>
                              <div className="text-left">
                                 <h4 className="text-xs font-black text-white uppercase tracking-widest text-left">ESTADO PRIVADO</h4>
                                 <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest mt-1 text-left">Exclusividad Garantizada</p>
                              </div>
                           </div>
                           <p className="text-[10px] text-zinc-400 leading-relaxed italic border-t border-white/5 pt-4">Búsqueda desactivada. Estás en una sesión privada.</p>
                        </motion.div>
                        <div className="flex gap-4">
                           <button onClick={() => { 
                              handleOpenChat(currentLive); 
                              setScreen('chat'); 
                              setDiscoveryState('searching'); 
                           }} className="h-16 flex-1 glass rounded-[28px] flex items-center justify-center gap-3 text-[10px] font-black uppercase tracking-[4px] text-white hover:bg-white/10 transition-all border-white/10 active:scale-95 shadow-2xl">
                              <MessageSquare size={20} />
                              ABRIR CHAT
                           </button>
                           <button onClick={() => { setDiscoveryState('searching'); setScreen('hub'); }} className="h-16 w-32 bg-red-500/10 border border-red-500/20 text-red-500 rounded-[28px] flex items-center justify-center transition-all active:scale-95 uppercase text-[9px] font-black tracking-widest">
                              COLGAR
                           </button>
                        </div>
                     </div>
                  )}
               </div>
            </div>

            {/* LIVE INDICATOR BORDERS */}
            <div className="absolute inset-0 border-[4px] border-primary/10 pointer-events-none" />
            <div className="absolute top-0 inset-x-0 h-1 bg-gradient-to-r from-transparent via-primary/40 to-transparent" />
          </div>
        );

      case 'trips':
        return (
          <div className="h-full flex flex-col pt-4 bg-[#050607]">
            <header className="px-6 py-4 flex items-center justify-between text-left">
               <div>
                  <h1 className="text-2xl font-black italic tracking-tighter text-left">Mis Viajes</h1>
                  <p className="text-[8px] text-primary font-bold tracking-[3px] uppercase mt-1 opacity-80">Centro de Itinerarios</p>
               </div>
               <div className="w-10 h-10 glass rounded-full flex items-center justify-center text-primary"><MapPin size={20} /></div>
            </header>

            <div className="flex-1 px-6 overflow-y-auto pb-32 scrollbar-hide space-y-8 text-left pt-4">
               {/* ACTIVE TRIP CARD */}
               <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="glass-card bg-gradient-to-b from-primary/10 to-transparent border-primary/20 p-0 rounded-[40px] overflow-hidden shadow-2xl relative">
                  <div className="h-48 relative">
                     <img src="/assets/santorini.png" className="w-full h-full object-cover grayscale-[0.2] brightness-[0.7]" />
                     <div className="absolute inset-0 bg-gradient-to-t from-[#050607] via-transparent to-transparent" />
                     <div className="absolute top-6 right-6 bg-safe/20 border border-safe/30 px-4 py-2 rounded-full backdrop-blur-md flex items-center gap-2">
                        <div className="w-2 h-2 bg-safe rounded-full animate-pulse" />
                        <p className="text-[9px] font-black text-safe uppercase tracking-widest">Protocolo Activo</p>
                     </div>
                  </div>
                  
                  <div className="p-8 pt-2">
                     <div className="flex justify-between items-start mb-6">
                        <div className="text-left">
                           <h3 className="text-4xl font-black text-white italic tracking-tighter">Santorini, GR</h3>
                           <p className="text-zinc-500 text-[10px] uppercase font-bold tracking-[4px] mt-1 italic">14 MAY - 21 MAY 2026</p>
                        </div>
                        <div className="text-right">
                           <p className="text-[9px] text-primary font-black uppercase tracking-[3px] mb-1">Escrow</p>
                           <p className="text-2xl font-black text-white italic">$2,500</p>
                        </div>
                     </div>

                     <div className="space-y-4 pt-6 border-t border-white/5">
                        <div className="flex items-center gap-4 group">
                           <div className="w-12 h-12 glass rounded-2xl flex items-center justify-center text-primary group-hover:bg-primary/20 transition-all"><Calendar size={22} /></div>
                           <div className="text-left">
                              <p className="text-[10px] text-white font-black uppercase tracking-widest text-left opacity-60">Próxima Actividad</p>
                              <p className="text-[12px] text-zinc-300 font-bold uppercase tracking-widest mt-1 text-left">Cena en Scorpios · 20:00</p>
                           </div>
                        </div>
                        <div className="flex items-center gap-4 group">
                           <div className="w-12 h-12 glass rounded-2xl flex items-center justify-center text-primary group-hover:bg-primary/20 transition-all"><ShieldCheck size={22} /></div>
                           <div className="text-left">
                              <p className="text-[10px] text-white font-black uppercase tracking-widest text-left opacity-60">Seguridad Elite</p>
                              <p className="text-[12px] text-zinc-300 font-bold uppercase tracking-widest mt-1 text-left">SLA v4.5 Verificado</p>
                           </div>
                        </div>
                     </div>
                     
                     <button onClick={() => toast("RESERVANDO CONCIERGE...", "gold")} className="w-full mt-8 py-5 glass border-primary/30 rounded-2xl text-primary text-[10px] font-black tracking-[4px] uppercase hover:bg-primary/10 transition-all">
                        Gestión de Concierge
                     </button>
                  </div>
               </motion.div>

               {/* PAST TRIPS HISTORY */}
               <div className="pb-10">
                  <div className="flex justify-between items-center mb-6 px-2">
                     <h4 className="text-[10px] font-black text-zinc-600 uppercase tracking-[4px]">Historial Elite</h4>
                     <p className="text-[9px] text-zinc-700 font-bold uppercase tracking-widest">3 Completados</p>
                  </div>
                  <div className="space-y-4">
                     {[
                        { city: 'Saint-Tropez', country: 'FR', date: 'AGO 2025', img: '/assets/brunna.png', partner: 'Brunna' },
                        { city: 'Mikonos', country: 'GR', date: 'JUL 2025', img: '/assets/isabella.png', partner: 'Isabella' },
                        { city: 'Amalfi', country: 'IT', date: 'JUN 2025', img: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150', partner: 'Elena' }
                     ].map((t, idx) => (
                        <div key={idx} className="glass-card p-4 rounded-[32px] border-white/5 bg-zinc-950/40 flex items-center gap-4 hover:border-primary/20 transition-all cursor-pointer group">
                           <div className="w-16 h-16 rounded-2xl overflow-hidden grayscale group-hover:grayscale-0 transition-all"><img src={t.img} className="w-full h-full object-cover" /></div>
                           <div className="flex-1 text-left">
                              <h5 className="text-md font-black text-white italic tracking-tighter leading-tight">{t.city}, {t.country}</h5>
                              <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-widest mt-1">Con {t.partner} · {t.date}</p>
                           </div>
                           <div className="w-10 h-10 glass rounded-full flex items-center justify-center text-safe/40"><CheckCircle2 size={18} /></div>
                        </div>
                     ))}
                  </div>
               </div>
            </div>
            
            <Navbar active="trips" role={role} onNav={(s) => setScreen(s)} />
          </div>
        );

      default:
        return <div className="h-full flex justify-center items-center text-zinc-800 uppercase tracking-widest text-xs">Section in Progress</div>
    }
  }

  return (
    <FullscreenContainer>
      <AnimatePresence mode="wait">
        <motion.div key={screen + role + (activeUser?.id || '') + chatMode} initial={{ opacity: 0, scale: 0.98 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 1.02 }} transition={{ duration: 0.3 }} className="h-full relative z-0">
          {renderScreen()}
        </motion.div>
      </AnimatePresence>

      {/* PROFILE PREVIEW MODAL GLOBAL */}
      <AnimatePresence>
         {isPreviewing && activeUser && (
            <motion.div initial={{ y: '100%' }} animate={{ y: 0 }} exit={{ y: '100%' }} transition={{ type: 'spring', damping: 25 }} className="absolute inset-0 z-[150] bg-[#050505] flex flex-col">
               <div className="h-[35%] relative shrink-0">
                  <img src={activeUser.img} className="w-full h-full object-cover" />
                  <div className="absolute inset-0 bg-gradient-to-t from-[#050505] via-transparent to-black/30" />
                  <button onClick={() => setIsPreviewing(false)} className="absolute top-12 left-6 w-9 h-9 glass rounded-full flex items-center justify-center text-white/80 active:scale-95 transition-all"><ChevronLeft size={18} /></button>
                  <button onClick={() => toast("ENLACE DE PERFIL COPIADO", "gold")} className="absolute top-12 right-6 w-9 h-9 glass rounded-full flex items-center justify-center text-white/80 active:scale-95 transition-all"><Share2 size={16} /></button>
                  
                  <div className="absolute bottom-4 left-7 right-7 text-left">
                     <div className="flex gap-2 mb-2">
                        <span className="bg-primary/20 text-primary text-[7px] font-black px-2 py-0.5 rounded-full border border-primary/20 uppercase tracking-[2px]">{activeUser.tag}</span>
                     </div>
                     <h2 className="text-3xl font-black text-white italic tracking-tighter leading-none">{activeUser.name}, {activeUser.age}</h2>
                     <p className="text-zinc-500 text-[10px] flex items-center gap-1.5 mt-1 font-bold"><MapPin size={10} className="text-primary/60" /> {activeUser.location}</p>
                  </div>
               </div>
               
               <div className="flex-1 px-7 py-5 space-y-6 overflow-y-auto pb-32 scrollbar-hide text-left">
                  {/* TRUST STATS COMPACT */}
                  <div className="flex items-center justify-between p-4 bg-white/[0.03] border border-white/5 rounded-[24px]">
                     <div className="flex-1 text-center group" onClick={() => toast("EXCELENTE REPUTACIÓN", 'gold')}>
                        <p className="text-[6px] text-zinc-600 font-black uppercase mb-1 tracking-widest group-hover:text-primary transition-colors">Elite Score</p>
                        <p className="text-[10px] font-black text-white italic">9.8</p>
                     </div>
                     <div className="w-[1px] h-6 bg-white/5" />
                     <div className="flex-1 text-center group cursor-pointer" onClick={() => setShowVouchModal(true)}>
                        <p className="text-[6px] text-zinc-600 font-black uppercase mb-1 tracking-widest group-hover:text-primary transition-colors">Avales</p>
                        <p className="text-[10px] font-black text-primary italic">12 Gold</p>
                     </div>
                     <div className="w-[1px] h-6 bg-white/5" />
                     <div className="flex-1 text-center group">
                        <p className="text-[6px] text-zinc-600 font-black uppercase mb-1 tracking-widest group-hover:text-primary transition-colors">Response</p>
                        <p className="text-[10px] font-black text-white italic">&lt; 15m</p>
                     </div>
                  </div>

                  {/* BIO COMPACT */}
                  <div>
                     <h4 className="text-[7px] font-black text-primary/40 uppercase tracking-[3px] mb-1.5">Executive Statement</h4>
                     <p className="text-zinc-400 text-[12px] leading-relaxed italic opacity-80">{activeUser.bio}</p>
                  </div>

                  {/* ATTRIBUTES COMPACT */}
                  <div className="flex flex-wrap gap-1.5">
                     {['Gourmet', 'Yacht Lover', 'Private Art', 'KYC Verified'].map(attr => (
                        <span key={attr} className="px-3 py-1.5 bg-zinc-900 border border-white/5 rounded-xl text-[7px] font-black text-zinc-500 uppercase tracking-widest hover:border-primary/40 hover:text-white transition-all cursor-default">{attr}</span>
                     ))}
                  </div>

                  {/* PRIVATE MOMENTS COMPACT */}
                  <div className="pt-2">
                      <div className="flex justify-between items-center mb-3">
                         <h4 className="text-[7px] font-black text-primary/40 uppercase tracking-[3px]">Momentos Privados</h4>
                         <p className="text-[7px] text-zinc-600 font-black uppercase tracking-widest">Locked</p>
                      </div>
                      <div className="grid grid-cols-4 gap-3">
                         {[1,2,3,4].map(i => (
                            <div key={i} className="aspect-square rounded-xl bg-zinc-900 border border-white/5 flex items-center justify-center overflow-hidden grayscale relative group cursor-pointer" onClick={() => toast("NIVEL PLATINUM REQUERIDO", "gold")}>
                               <div className="absolute inset-0 bg-black/70 backdrop-blur-[1px] z-10 opacity-100 group-hover:opacity-0 transition-opacity" />
                               <Lock size={12} className="text-zinc-800 z-20 relative transition-transform group-hover:scale-125" />
                            </div>
                         ))}
                      </div>
                  </div>

                  {/* UNIFIED ACTION HUB COMPACT */}
                  <div className="flex gap-2.5 pt-4 pb-10">
                     <button onClick={() => { setIsPreviewing(false); setIsCalling(true); }} className="h-14 w-14 glass rounded-[20px] flex items-center justify-center text-primary border-primary/10 shadow-xl active:scale-95 transition-all hover:bg-primary/5">
                        <Video size={18} />
                     </button>
                     <button onClick={() => handleOpenChat(activeUser)} className="h-14 flex-1 btn-gold rounded-[20px] flex items-center justify-center gap-2.5 text-[9px] font-black tracking-[4px] uppercase shadow-[0_10px_30px_rgba(197,168,128,0.2)] active:scale-95 transition-all">
                        <MessageSquare size={16} />
                        Iniciar Chat
                     </button>
                  </div>
               </div>

               <AnimatePresence>
                  {showVouchModal && (
                     <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.9 }} className="absolute inset-0 z-[200] flex items-center justify-center px-10 bg-black/80 backdrop-blur-xl" onClick={() => setShowVouchModal(false)}>
                        <div className="glass p-8 rounded-[40px] border-primary/30 shadow-2xl text-center max-w-sm">
                           <div className="w-16 h-16 bg-primary/10 rounded-3xl flex items-center justify-center mx-auto mb-6 border border-primary/20"><Gem size={32} className="text-primary" /></div>
                           <h4 className="text-primary font-black text-xs mb-3 uppercase tracking-[4px]">Reputación Elite</h4>
                           <p className="text-white font-black text-xl italic tracking-tighter mb-4">Avalada por 12 Miembros Platinum</p>
                           <p className="text-[11px] text-zinc-500 font-bold uppercase tracking-widest leading-relaxed">Este perfil ha sido verificado manualmente por miembros de confianza en la red privada.</p>
                        </div>
                     </motion.div>
                  )}
               </AnimatePresence>
            </motion.div>
         )}
      </AnimatePresence>


      <ToastHandler />

      {/* VIDEO CALL INTERFACE */}
      <AnimatePresence>
         {isCalling && activeUser && (
            <motion.div initial={{ y: '100%' }} animate={{ y: 0 }} exit={{ y: '100%' }} transition={{ type: 'spring', damping: 20 }} className="absolute inset-0 z-[500] bg-black">
               <img src={activeUser.img} className="w-full h-full object-cover grayscale-[0.5] filter brightness-[0.3] blur-[4px]" />
               <div className="absolute inset-x-0 top-24 px-10 flex flex-col items-center text-center">
                  <div className="relative mb-8 mx-auto">
                    <div className="absolute -inset-4 rounded-full border-2 border-primary/40 animate-ping" />
                    <div className="w-48 h-48 rounded-full p-1.5 border-2 border-primary shadow-[0_0_60px_rgba(197,168,128,0.4)] relative overflow-hidden">
                      <img src={activeUser.img} className="w-full h-full rounded-full object-cover" />
                    </div>
                  </div>
                  <h3 className="text-4xl font-black text-white italic tracking-tighter mb-2 text-center">{activeUser.name}</h3>
                  <p className="text-primary font-black uppercase tracking-[6px] text-[10px] opacity-80 text-center">Conexión Segura P2P</p>
               </div>

               <div className="absolute inset-x-0 bottom-24 flex flex-col items-center gap-12 px-10 text-center">
                  <div className="flex gap-10 justify-center">
                    <button className="w-16 h-16 glass rounded-full flex justify-center items-center text-white border-white/10 active:bg-white/10 transition-all"><VideoOff size={24} /></button>
                    <button className="w-16 h-16 glass rounded-full flex justify-center items-center text-white border-white/10 active:bg-white/10 transition-all"><Mic size={24} /></button>
                  </div>
                  <button onClick={() => setIsCalling(false)} className="w-full h-24 bg-red-600 rounded-[40px] shadow-[0_20px_50px_rgba(220,38,38,0.3)] flex justify-center items-center group relative overflow-hidden active:scale-95 transition-all">
                    <div className="absolute inset-0 bg-white/10 animate-pulse pointer-events-none" />
                    <div className="flex items-center gap-4 relative z-10 text-white justify-center">
                       <PhoneOff size={28} />
                       <span className="text-lg font-black tracking-[4px] uppercase">Finalizar</span>
                    </div>
                  </button>
               </div>
               
               <div className="absolute top-12 left-6 w-24 h-32 bg-zinc-900/80 rounded-2xl overflow-hidden border border-white/10 shadow-2xl backdrop-blur-md">
                  <div className="w-full h-full flex items-center justify-center text-center p-2">
                    <span className="text-[7px] text-zinc-500 font-black uppercase leading-tight tracking-widest text-center">Cámara Desactivada</span>
                  </div>
               </div>
            </motion.div>
         )}
      </AnimatePresence>

      {/* SOS BUTTONS */}
      {role === 'female' && tripStatus === 'active' && screen === 'trips' && (
        <div className="absolute bottom-28 right-8 flex flex-col items-center gap-4 z-[90]">
           <div className="flex flex-col gap-3">
              <button onClick={() => toast("RESCATE SILENCIOSO ACTIVADO", 'danger')} className="w-12 h-12 bg-zinc-950 border border-danger/40 rounded-[22px] flex justify-center items-center text-danger hover:bg-danger/10 shadow-2xl transition-all"><Lock size={20} strokeWidth={2.5} /></button>
              <button onClick={() => alert("SOS ACTIVO. PROCEDIMIENTO DE SOPORTE TRIPWIFE INICIADO.")} className="w-18 h-18 bg-danger rounded-[28px] shadow-[0_0_60px_rgba(233,69,96,0.6)] flex justify-center items-center group relative active:scale-95 transition-all">
                <div className="absolute inset-0 bg-white/20 animate-pulse pointer-events-none" />
                <AlertTriangle size={36} className="text-white relative z-10" />
              </button>
           </div>
        </div>
      )}

    </FullscreenContainer>
  );
}

function ToastHandler() {
  const [toast, setToast] = useState<{msg: string, color: string} | null>(null);
  useEffect(() => {
    const handler = (e: any) => {
      setToast(e.detail);
      setTimeout(() => setToast(null), 3500);
    };
    window.addEventListener('app-toast', handler);
    return () => window.removeEventListener('app-toast', handler);
  }, []);

  return (
    <AnimatePresence>
      {toast && (
        <motion.div initial={{ y: -70, opacity: 0, x: '-50%' }} animate={{ y: 0, opacity: 1, x: '-50%' }} exit={{ y: -70, opacity: 0, x: '-50%' }} className="absolute top-24 left-1/2 -translate-x-1/2 z-[3000] w-[85%] px-6 py-4 rounded-[28px] filter backdrop-blur-3xl border flex items-center gap-4 shadow-2xl" style={{ backgroundColor: 'rgba(0,0,0,0.95)', borderColor: `${toast.color}44` }}>
           <div className="w-2 h-2 rounded-full animate-ping shrink-0" style={{ backgroundColor: toast.color }} />
           <span className="text-[10px] font-black uppercase tracking-[3px] text-center w-full" style={{ color: toast.color }}>{toast.msg}</span>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
