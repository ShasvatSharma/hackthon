import React, { useState, useEffect } from 'react';
import { LayoutDashboard, Map, Bell, Settings, Menu, X, Search, Filter, Users, AlertTriangle, Shield, MapPin, Clock, Car, ParkingCircle, Cloud, Sun, CloudRain, Thermometer, TrendingUp, TrendingDown, Ticket, ChevronLeft, Landmark, Trees, Sparkles, Waves, User, Camera, Edit2, LogOut, Mail, Phone, Check, MessageCircle, Send, Heart, Smile, UsersRound, Calendar, Globe, Star, Download, Share2, Smartphone, QrCode } from 'lucide-react';

const CITIES = [
    {
        id: 'delhi', name: 'Delhi', country: 'India', emoji: '🏛️', spots: [
            { id: 'd1', name: 'Red Fort', category: 'heritage', crowd: 85, desc: 'Mughal-era imperial residence', hours: '9AM-5PM', price: '₹35' },
            { id: 'd2', name: 'Qutub Minar', category: 'heritage', crowd: 72, desc: 'Tallest brick minaret', hours: '7AM-5PM', price: '₹35' },
            { id: 'd3', name: 'India Gate', category: 'heritage', crowd: 88, desc: 'War memorial archway', hours: '24/7', price: 'Free' },
            { id: 'd4', name: 'Lotus Temple', category: 'spiritual', crowd: 65, desc: 'Bahá\'í House of Worship', hours: '9AM-5PM', price: 'Free' },
            { id: 'd5', name: 'Humayun\'s Tomb', category: 'heritage', crowd: 55, desc: 'Mughal architecture marvel', hours: '6AM-6PM', price: '₹35' },
            { id: 'd6', name: 'Akshardham Temple', category: 'spiritual', crowd: 78, desc: 'Grand Hindu temple complex', hours: '10AM-6PM', price: 'Free' },
            { id: 'd7', name: 'Jama Masjid', category: 'spiritual', crowd: 62, desc: 'Largest mosque in India', hours: '7AM-12PM', price: 'Free' },
            { id: 'd8', name: 'Lodhi Garden', category: 'nature', crowd: 35, desc: 'Historic park with tombs', hours: '6AM-8PM', price: 'Free' },
            { id: 'd9', name: 'Chandni Chowk', category: 'leisure', crowd: 92, desc: 'Historic market street', hours: '10AM-8PM', price: 'Free' },
            { id: 'd10', name: 'Rashtrapati Bhavan', category: 'heritage', crowd: 45, desc: 'Presidential residence', hours: '9AM-4PM', price: '₹50' }
        ]
    },
    {
        id: 'mumbai', name: 'Mumbai', country: 'India', emoji: '🌊', spots: [
            { id: 'm1', name: 'Gateway of India', category: 'heritage', crowd: 89, desc: 'Iconic waterfront arch', hours: '24/7', price: 'Free' },
            { id: 'm2', name: 'Marine Drive', category: 'leisure', crowd: 75, desc: 'Queen\'s Necklace promenade', hours: '24/7', price: 'Free' },
            { id: 'm3', name: 'Elephanta Caves', category: 'heritage', crowd: 58, desc: 'UNESCO rock-cut temples', hours: '9AM-5PM', price: '₹40' },
            { id: 'm4', name: 'Siddhivinayak Temple', category: 'spiritual', crowd: 95, desc: 'Famous Ganesh temple', hours: '5AM-10PM', price: 'Free' },
            { id: 'm5', name: 'Chhatrapati Shivaji Terminus', category: 'heritage', crowd: 82, desc: 'Victorian Gothic railway station', hours: '24/7', price: 'Free' },
            { id: 'm6', name: 'Juhu Beach', category: 'nature', crowd: 68, desc: 'Popular beach destination', hours: '24/7', price: 'Free' },
            { id: 'm7', name: 'Haji Ali Dargah', category: 'spiritual', crowd: 72, desc: 'Mosque on sea islet', hours: '6AM-10PM', price: 'Free' },
            { id: 'm8', name: 'Sanjay Gandhi National Park', category: 'nature', crowd: 42, desc: 'Urban forest reserve', hours: '7AM-6PM', price: '₹53' },
            { id: 'm9', name: 'Film City', category: 'leisure', crowd: 55, desc: 'Bollywood studios', hours: '10AM-5PM', price: '₹500' },
            { id: 'm10', name: 'Colaba Causeway', category: 'leisure', crowd: 78, desc: 'Shopping street', hours: '10AM-9PM', price: 'Free' }
        ]
    },
    {
        id: 'agra', name: 'Agra', country: 'India', emoji: '🕌', spots: [
            { id: 'a1', name: 'Taj Mahal', category: 'heritage', crowd: 95, desc: 'Symbol of eternal love', hours: '6AM-6PM', price: '₹50' },
            { id: 'a2', name: 'Agra Fort', category: 'heritage', crowd: 78, desc: 'UNESCO World Heritage', hours: '6AM-6PM', price: '₹50' },
            { id: 'a3', name: 'Fatehpur Sikri', category: 'heritage', crowd: 62, desc: 'Abandoned Mughal city', hours: '6AM-6PM', price: '₹50' },
            { id: 'a4', name: 'Mehtab Bagh', category: 'nature', crowd: 48, desc: 'Garden with Taj view', hours: '6AM-6PM', price: '₹30' },
            { id: 'a5', name: 'Itmad-ud-Daulah', category: 'heritage', crowd: 35, desc: 'Baby Taj marble tomb', hours: '6AM-6PM', price: '₹30' },
            { id: 'a6', name: 'Akbar\'s Tomb', category: 'heritage', crowd: 42, desc: 'Mughal emperor\'s mausoleum', hours: '6AM-6PM', price: '₹35' },
            { id: 'a7', name: 'Jama Masjid Agra', category: 'spiritual', crowd: 32, desc: 'Historic mosque', hours: '6AM-8PM', price: 'Free' },
            { id: 'a8', name: 'Kinari Bazaar', category: 'leisure', crowd: 72, desc: 'Traditional market', hours: '10AM-9PM', price: 'Free' },
            { id: 'a9', name: 'Anguri Bagh', category: 'nature', crowd: 28, desc: 'Mughal garden', hours: '6AM-6PM', price: '₹20' },
            { id: 'a10', name: 'Dayal Bagh Temple', category: 'spiritual', crowd: 25, desc: 'Radhasoami temple', hours: '8AM-6PM', price: 'Free' }
        ]
    },
    {
        id: 'jaipur', name: 'Jaipur', country: 'India', emoji: '🏰', spots: [
            { id: 'j1', name: 'Hawa Mahal', category: 'heritage', crowd: 88, desc: 'Palace of Winds', hours: '9AM-5PM', price: '₹50' },
            { id: 'j2', name: 'Amber Fort', category: 'heritage', crowd: 85, desc: 'Hilltop fortress palace', hours: '8AM-5PM', price: '₹100' },
            { id: 'j3', name: 'City Palace', category: 'heritage', crowd: 75, desc: 'Royal residence complex', hours: '9AM-5PM', price: '₹200' },
            { id: 'j4', name: 'Jantar Mantar', category: 'heritage', crowd: 55, desc: 'Astronomical observatory', hours: '9AM-5PM', price: '₹50' },
            { id: 'j5', name: 'Nahargarh Fort', category: 'heritage', crowd: 62, desc: 'Tiger Fort with city views', hours: '10AM-5PM', price: '₹50' },
            { id: 'j6', name: 'Jal Mahal', category: 'heritage', crowd: 72, desc: 'Water Palace', hours: '24/7', price: 'Free' },
            { id: 'j7', name: 'Birla Mandir', category: 'spiritual', crowd: 48, desc: 'White marble temple', hours: '8AM-12PM', price: 'Free' },
            { id: 'j8', name: 'Albert Hall Museum', category: 'heritage', crowd: 42, desc: 'State museum', hours: '9AM-5PM', price: '₹40' },
            { id: 'j9', name: 'Johari Bazaar', category: 'leisure', crowd: 82, desc: 'Jewellery market', hours: '10AM-8PM', price: 'Free' },
            { id: 'j10', name: 'Galtaji Temple', category: 'spiritual', crowd: 38, desc: 'Monkey Temple', hours: '5AM-9PM', price: 'Free' }
        ]
    },
    {
        id: 'varanasi', name: 'Varanasi', country: 'India', emoji: '🙏', spots: [
            { id: 'v1', name: 'Dashashwamedh Ghat', category: 'spiritual', crowd: 92, desc: 'Main ghat with Ganga Aarti', hours: '24/7', price: 'Free' },
            { id: 'v2', name: 'Kashi Vishwanath Temple', category: 'spiritual', crowd: 95, desc: 'Jyotirlinga temple', hours: '3AM-11PM', price: 'Free' },
            { id: 'v3', name: 'Assi Ghat', category: 'spiritual', crowd: 68, desc: 'Peaceful riverside ghat', hours: '24/7', price: 'Free' },
            { id: 'v4', name: 'Sarnath', category: 'spiritual', crowd: 55, desc: 'Buddha\'s first sermon site', hours: '9AM-5PM', price: '₹25' },
            { id: 'v5', name: 'Manikarnika Ghat', category: 'spiritual', crowd: 78, desc: 'Sacred cremation ground', hours: '24/7', price: 'Free' },
            { id: 'v6', name: 'Ramnagar Fort', category: 'heritage', crowd: 42, desc: 'Maharaja\'s fort museum', hours: '10AM-5PM', price: '₹30' },
            { id: 'v7', name: 'Tulsi Manas Temple', category: 'spiritual', crowd: 52, desc: 'Modern marble temple', hours: '5AM-9PM', price: 'Free' },
            { id: 'v8', name: 'Bharat Mata Temple', category: 'spiritual', crowd: 35, desc: 'Mother India temple', hours: '9AM-6PM', price: 'Free' },
            { id: 'v9', name: 'Vishwanath Gali', category: 'leisure', crowd: 85, desc: 'Temple lane market', hours: '6AM-10PM', price: 'Free' },
            { id: 'v10', name: 'Chunar Fort', category: 'heritage', crowd: 28, desc: 'Ancient hilltop fort', hours: '8AM-5PM', price: '₹25' }
        ]
    },
    {
        id: 'kolkata', name: 'Kolkata', country: 'India', emoji: '🎭', spots: [
            { id: 'k1', name: 'Victoria Memorial', category: 'heritage', crowd: 82, desc: 'Marble building museum', hours: '10AM-5PM', price: '₹30' },
            { id: 'k2', name: 'Howrah Bridge', category: 'heritage', crowd: 78, desc: 'Iconic cantilever bridge', hours: '24/7', price: 'Free' },
            { id: 'k3', name: 'Dakshineswar Kali Temple', category: 'spiritual', crowd: 88, desc: 'Famous Kali temple', hours: '6AM-12PM', price: 'Free' },
            { id: 'k4', name: 'Indian Museum', category: 'heritage', crowd: 55, desc: 'Largest museum in India', hours: '10AM-5PM', price: '₹50' },
            { id: 'k5', name: 'Belur Math', category: 'spiritual', crowd: 62, desc: 'Ramakrishna Mission HQ', hours: '6AM-12PM', price: 'Free' },
            { id: 'k6', name: 'Park Street', category: 'leisure', crowd: 75, desc: 'Restaurant & nightlife hub', hours: '24/7', price: 'Free' },
            { id: 'k7', name: 'Marble Palace', category: 'heritage', crowd: 38, desc: '19th-century mansion', hours: '10AM-4PM', price: 'Free' },
            { id: 'k8', name: 'Princep Ghat', category: 'leisure', crowd: 58, desc: 'Riverside promenade', hours: '24/7', price: 'Free' },
            { id: 'k9', name: 'Science City', category: 'leisure', crowd: 65, desc: 'Science museum complex', hours: '9AM-8PM', price: '₹60' },
            { id: 'k10', name: 'Eden Gardens', category: 'leisure', crowd: 45, desc: 'Historic cricket stadium', hours: '10AM-5PM', price: '₹50' }
        ]
    },
    {
        id: 'chennai', name: 'Chennai', country: 'India', emoji: '🏖️', spots: [
            { id: 'ch1', name: 'Marina Beach', category: 'nature', crowd: 85, desc: 'Second longest urban beach', hours: '24/7', price: 'Free' },
            { id: 'ch2', name: 'Kapaleeshwarar Temple', category: 'spiritual', crowd: 78, desc: 'Dravidian architecture gem', hours: '5AM-12PM', price: 'Free' },
            { id: 'ch3', name: 'Fort St. George', category: 'heritage', crowd: 52, desc: 'First English fortress', hours: '9AM-5PM', price: '₹25' },
            { id: 'ch4', name: 'Mahabalipuram', category: 'heritage', crowd: 72, desc: 'UNESCO shore temples', hours: '6AM-6PM', price: '₹40' },
            { id: 'ch5', name: 'Government Museum', category: 'heritage', crowd: 42, desc: 'Art and archaeology', hours: '9AM-5PM', price: '₹15' },
            { id: 'ch6', name: 'Valluvar Kottam', category: 'heritage', crowd: 35, desc: 'Temple-chariot monument', hours: '8AM-6PM', price: '₹10' },
            { id: 'ch7', name: 'Parthasarathy Temple', category: 'spiritual', crowd: 62, desc: 'Ancient Vishnu temple', hours: '6AM-12PM', price: 'Free' },
            { id: 'ch8', name: 'Guindy National Park', category: 'nature', crowd: 48, desc: 'Urban wildlife sanctuary', hours: '9AM-5PM', price: '₹30' },
            { id: 'ch9', name: 'T Nagar', category: 'leisure', crowd: 88, desc: 'Shopping district', hours: '10AM-9PM', price: 'Free' },
            { id: 'ch10', name: 'San Thome Basilica', category: 'spiritual', crowd: 45, desc: 'Apostle Thomas church', hours: '6AM-8PM', price: 'Free' }
        ]
    },
    {
        id: 'hyderabad', name: 'Hyderabad', country: 'India', emoji: '💎', spots: [
            { id: 'h1', name: 'Charminar', category: 'heritage', crowd: 88, desc: 'Iconic monument & mosque', hours: '9AM-5PM', price: '₹25' },
            { id: 'h2', name: 'Golconda Fort', category: 'heritage', crowd: 75, desc: 'Medieval diamond fort', hours: '9AM-5PM', price: '₹25' },
            { id: 'h3', name: 'Ramoji Film City', category: 'leisure', crowd: 82, desc: 'World\'s largest film studio', hours: '9AM-8PM', price: '₹1500' },
            { id: 'h4', name: 'Hussain Sagar Lake', category: 'nature', crowd: 65, desc: 'Heart-shaped lake', hours: '24/7', price: 'Free' },
            { id: 'h5', name: 'Salar Jung Museum', category: 'heritage', crowd: 58, desc: 'Art treasures collection', hours: '10AM-5PM', price: '₹20' },
            { id: 'h6', name: 'Birla Mandir', category: 'spiritual', crowd: 62, desc: 'Hilltop marble temple', hours: '7AM-12PM', price: 'Free' },
            { id: 'h7', name: 'Qutb Shahi Tombs', category: 'heritage', crowd: 42, desc: 'Royal necropolis', hours: '9AM-5PM', price: '₹25' },
            { id: 'h8', name: 'Laad Bazaar', category: 'leisure', crowd: 78, desc: 'Bangle market', hours: '10AM-9PM', price: 'Free' },
            { id: 'h9', name: 'Nehru Zoological Park', category: 'nature', crowd: 55, desc: 'Large city zoo', hours: '8AM-5PM', price: '₹40' },
            { id: 'h10', name: 'Mecca Masjid', category: 'spiritual', crowd: 52, desc: 'Largest mosque in city', hours: '4AM-9PM', price: 'Free' }
        ]
    },
    {
        id: 'udaipur', name: 'Udaipur', country: 'India', emoji: '🏯', spots: [
            { id: 'u1', name: 'City Palace', category: 'heritage', crowd: 85, desc: 'Lakeside royal palace', hours: '9AM-5PM', price: '₹300' },
            { id: 'u2', name: 'Lake Pichola', category: 'nature', crowd: 78, desc: 'Artificial freshwater lake', hours: '24/7', price: 'Free' },
            { id: 'u3', name: 'Jag Mandir', category: 'heritage', crowd: 62, desc: 'Island palace', hours: '10AM-6PM', price: '₹450' },
            { id: 'u4', name: 'Jagdish Temple', category: 'spiritual', crowd: 55, desc: 'Indo-Aryan Vishnu temple', hours: '5AM-2PM', price: 'Free' },
            { id: 'u5', name: 'Saheliyon Ki Bari', category: 'nature', crowd: 48, desc: 'Garden of the Maidens', hours: '9AM-6PM', price: '₹10' },
            { id: 'u6', name: 'Monsoon Palace', category: 'heritage', crowd: 72, desc: 'Hilltop palace with views', hours: '10AM-6PM', price: '₹80' },
            { id: 'u7', name: 'Fateh Sagar Lake', category: 'nature', crowd: 65, desc: 'Scenic artificial lake', hours: '24/7', price: 'Free' },
            { id: 'u8', name: 'Bagore Ki Haveli', category: 'heritage', crowd: 58, desc: 'Historic aristocratic mansion', hours: '10AM-6PM', price: '₹100' },
            { id: 'u9', name: 'Shilpgram', category: 'leisure', crowd: 42, desc: 'Crafts village', hours: '11AM-7PM', price: '₹50' },
            { id: 'u10', name: 'Eklingji Temple', category: 'spiritual', crowd: 45, desc: 'Shiva temple complex', hours: '10AM-1PM', price: 'Free' }
        ]
    },
    {
        id: 'goa', name: 'Goa', country: 'India', emoji: '🏝️', spots: [
            { id: 'g1', name: 'Calangute Beach', category: 'nature', crowd: 88, desc: 'Queen of beaches', hours: '24/7', price: 'Free' },
            { id: 'g2', name: 'Basilica of Bom Jesus', category: 'spiritual', crowd: 65, desc: 'UNESCO World Heritage church', hours: '9AM-6PM', price: 'Free' },
            { id: 'g3', name: 'Fort Aguada', category: 'heritage', crowd: 72, desc: '17th-century Portuguese fort', hours: '9AM-5PM', price: '₹25' },
            { id: 'g4', name: 'Anjuna Beach', category: 'nature', crowd: 78, desc: 'Famous hippie beach', hours: '24/7', price: 'Free' },
            { id: 'g5', name: 'Dudhsagar Falls', category: 'nature', crowd: 62, desc: 'Four-tiered waterfall', hours: '8AM-5PM', price: '₹400' },
            { id: 'g6', name: 'Se Cathedral', category: 'spiritual', crowd: 48, desc: 'Largest church in Asia', hours: '7AM-6PM', price: 'Free' },
            { id: 'g7', name: 'Palolem Beach', category: 'nature', crowd: 55, desc: 'Crescent-shaped beach', hours: '24/7', price: 'Free' },
            { id: 'g8', name: 'Chapora Fort', category: 'heritage', crowd: 82, desc: 'Dil Chahta Hai fort', hours: '9AM-5PM', price: 'Free' },
            { id: 'g9', name: 'Anjuna Flea Market', category: 'leisure', crowd: 85, desc: 'Wednesday market', hours: '9AM-6PM', price: 'Free' },
            { id: 'g10', name: 'Shri Mangueshi Temple', category: 'spiritual', crowd: 52, desc: 'Famous Shiva temple', hours: '6AM-9PM', price: 'Free' }
        ]
    }
];

const CATEGORIES = [
    { id: 'all', name: 'All', icon: Filter },
    { id: 'heritage', name: 'Heritage', icon: Landmark },
    { id: 'nature', name: 'Nature', icon: Trees },
    { id: 'spiritual', name: 'Spiritual', icon: Sparkles },
    { id: 'leisure', name: 'Leisure', icon: Waves }
];

const getColors = (dark) => dark ? {
    bg: '#0f172a', white: '#1e293b', slate900: '#f1f5f9', slate700: '#cbd5e1',
    slate500: '#94a3b8', slate400: '#64748b', slate200: '#334155', slate100: '#1e293b',
    indigo600: '#818cf8', indigo700: '#6366f1', indigo100: '#312e81',
    violet500: '#a78bfa', emerald500: '#34d399', emerald100: '#064e3b',
    amber500: '#fbbf24', amber100: '#78350f', rose600: '#fb7185', rose100: '#881337',
    purple600: '#c084fc', purple100: '#581c87', orange500: '#fb923c', orange100: '#7c2d12'
} : {
    bg: '#f8fafc', white: '#ffffff', slate900: '#0f172a', slate700: '#334155',
    slate500: '#64748b', slate400: '#94a3b8', slate200: '#e2e8f0', slate100: '#f1f5f9',
    indigo600: '#4f46e5', indigo700: '#4338ca', indigo100: '#e0e7ff',
    violet500: '#8b5cf6', emerald500: '#10b981', emerald100: '#d1fae5',
    amber500: '#f59e0b', amber100: '#fef3c7', rose600: '#e11d48', rose100: '#ffe4e6',
    purple600: '#9333ea', purple100: '#f3e8ff', orange500: '#f97316', orange100: '#ffedd5'
};

export default function CityPulseWeb() {
    const [view, setView] = useState('dashboard');
    const [selectedCity, setSelectedCity] = useState(null);
    const [selectedSpot, setSelectedSpot] = useState(null);
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [search, setSearch] = useState('');
    const [category, setCategory] = useState('all');
    const [telemetry, setTelemetry] = useState(null);
    const [loading, setLoading] = useState(false);
    const [isMobile, setIsMobile] = useState(typeof window !== 'undefined' && window.innerWidth < 1024);
    const [isRegistered, setIsRegistered] = useState(false);
    const [showRegister, setShowRegister] = useState(false);
    const [userProfile, setUserProfile] = useState({ name: '', email: '', phone: '', avatar: 0 });
    const [darkMode, setDarkMode] = useState(false);
    const [chatOpen, setChatOpen] = useState(false);
    const [chatMessages, setChatMessages] = useState([
        { from: 'bot', text: "Hey there! 👋 I'm TourBot, your Smart Tourism IQ assistant! How are you feeling today? Looking for somewhere peaceful to explore?" }
    ]);
    const [chatInput, setChatInput] = useState('');
    const avatarColors = ['#f97316', '#8b5cf6', '#10b981', '#e11d48', '#0ea5e9', '#f59e0b'];
    const colors = getColors(darkMode);
    const getCrowdColor = (crowd) => {
        if (crowd >= 86) return { bg: colors.purple100, text: colors.purple600, label: 'Surge' };
        if (crowd >= 61) return { bg: colors.rose100, text: colors.rose600, label: 'High' };
        if (crowd >= 31) return { bg: colors.amber100, text: colors.amber500, label: 'Medium' };
        return { bg: colors.emerald100, text: colors.emerald500, label: 'Low' };
    };

    // Find safest spots across all cities
    const getSafeSpots = () => {
        const allSpots = CITIES.flatMap(c => c.spots.map(s => ({ ...s, city: c.name })));
        return allSpots.filter(s => s.crowd < 40).sort((a, b) => a.crowd - b.crowd).slice(0, 5);
    };

    const getBotResponse = (userMsg) => {
        const msg = userMsg.toLowerCase();
        const safeSpots = getSafeSpots();
        const greetings = ['hi', 'hello', 'hey', 'namaste', 'good'];
        const feelingWords = ['tired', 'stressed', 'sad', 'anxious', 'lonely', 'bored'];
        const peaceWords = ['peace', 'quiet', 'calm', 'relax', 'serene', 'safe'];
        const funWords = ['fun', 'exciting', 'adventure', 'thrill'];
        const spiritualWords = ['temple', 'spiritual', 'pray', 'meditate', 'god'];
        const natureWords = ['nature', 'garden', 'park', 'green', 'beach', 'lake'];

        if (greetings.some(g => msg.includes(g))) {
            return `Hello, dear friend! 🌸 So happy you're here! India has so many beautiful places waiting for you. Are you looking for something peaceful, adventurous, or spiritual today?`;
        }
        if (feelingWords.some(f => msg.includes(f))) {
            const spot = safeSpots[0];
            return `Oh, I understand... 💝 When we feel that way, nature and quiet places can really help. Here's a cozy suggestion just for you:\n\n🌿 **${spot.name}** in ${spot.city}\nOnly ${spot.crowd}% crowded right now - very peaceful!\n${spot.desc}\n\nTake your time, breathe deeply, and know that you're doing great! 🤗`;
        }
        if (peaceWords.some(p => msg.includes(p))) {
            const spots = safeSpots.slice(0, 3);
            return `Looking for peace? I've got you covered, my friend! 🕊️\n\nHere are the most tranquil spots right now:\n\n${spots.map((s, i) => `${i + 1}. 🌸 **${s.name}** (${s.city}) - only ${s.crowd}% busy`).join('\n')}\n\nThese places will make your soul feel light and happy! ✨`;
        }
        if (spiritualWords.some(s => msg.includes(s))) {
            const spiritual = CITIES.flatMap(c => c.spots.filter(s => s.category === 'spiritual').map(s => ({ ...s, city: c.name }))).sort((a, b) => a.crowd - b.crowd).slice(0, 3);
            return `Seeking spiritual connection? Beautiful! 🙏\n\nHere are sacred places with peaceful vibes:\n\n${spiritual.map((s, i) => `${i + 1}. 🛕 **${s.name}** (${s.city}) - ${s.crowd}% crowded`).join('\n')}\n\nMay you find the peace you're looking for! 💫`;
        }
        if (natureWords.some(n => msg.includes(n))) {
            const nature = CITIES.flatMap(c => c.spots.filter(s => s.category === 'nature').map(s => ({ ...s, city: c.name }))).sort((a, b) => a.crowd - b.crowd).slice(0, 3);
            return `Nature lover! 🌳 I love that about you!\n\nHere are beautiful natural escapes:\n\n${nature.map((s, i) => `${i + 1}. 🌿 **${s.name}** (${s.city}) - ${s.crowd}% crowded`).join('\n')}\n\nNature always knows how to heal us! 🦋`;
        }
        if (funWords.some(f => msg.includes(f))) {
            const leisure = CITIES.flatMap(c => c.spots.filter(s => s.category === 'leisure').map(s => ({ ...s, city: c.name }))).slice(0, 3);
            return `Ready for some fun? Yay! 🎉\n\nHere are exciting places:\n\n${leisure.map((s, i) => `${i + 1}. 🎭 **${s.name}** (${s.city}) - ${s.desc}`).join('\n')}\n\nGo make some amazing memories! 🌟`;
        }
        if (msg.includes('thank')) {
            return `Aww, you're so welcome! 💖 It makes me so happy to help you explore our beautiful India. Take care of yourself, and remember - every journey starts with a single step! 🚶‍♂️✨`;
        }
        if (msg.includes('safe') || msg.includes('crowd')) {
            const spot = safeSpots[0];
            return `Safety first! 🛡️ I always look out for my friends.\n\nThe safest spot right now is:\n\n🌟 **${spot.name}** in ${spot.city}\nOnly ${spot.crowd}% crowded!\n\nYou can explore peacefully without any rush! 💚`;
        }

        // Default friendly response
        return `That's interesting! 😊 Let me suggest some wonderful places for you:\n\n${safeSpots.slice(0, 2).map((s, i) => `${i + 1}. **${s.name}** in ${s.city} (${s.crowd}% crowded)`).join('\n')}\n\nWould you like something peaceful, spiritual, or adventurous? I'm here to help! 🤗`;
    };

    const sendMessage = () => {
        if (!chatInput.trim()) return;
        const userMsg = { from: 'user', text: chatInput };
        setChatMessages(prev => [...prev, userMsg]);
        setChatInput('');
        // Simulate typing delay
        setTimeout(() => {
            const botResponse = { from: 'bot', text: getBotResponse(chatInput) };
            setChatMessages(prev => [...prev, botResponse]);
        }, 800);
    };

    useEffect(() => {
        const handleResize = () => setIsMobile(window.innerWidth < 1024);
        window.addEventListener('resize', handleResize);
        return () => window.removeEventListener('resize', handleResize);
    }, []);

    const totalVisitors = CITIES.reduce((sum, c) => sum + c.spots.reduce((s, sp) => s + sp.crowd * 1000, 0), 0);
    const activeAlerts = CITIES.reduce((sum, c) => sum + c.spots.filter(s => s.crowd >= 80).length, 0);
    const safestCity = CITIES.reduce((a, b) => (a.spots.reduce((s, sp) => s + sp.crowd, 0) / a.spots.length) < (b.spots.reduce((s, sp) => s + sp.crowd, 0) / b.spots.length) ? a : b);

    useEffect(() => {
        if (selectedSpot) {
            setLoading(true); setTelemetry(null);
            const timer = setTimeout(() => {
                const crowd = selectedSpot.crowd;
                const isHigh = crowd > 80, isLow = crowd < 30;
                const forecast = Array.from({ length: 12 }, (_, i) => {
                    let val = crowd + (isHigh ? -((i + 1) * 5) : isLow ? ((i + 1) * 4) : (Math.random() - 0.5) * 15);
                    return Math.max(10, Math.min(95, val));
                });
                setTelemetry({ traffic: isHigh ? 'Gridlock' : isLow ? 'Fluid' : 'Moderate', parking: isHigh ? 8 : isLow ? 78 : 45, weather: isHigh ? 'sunny' : isLow ? 'rainy' : 'cloudy', temp: isHigh ? 34 : isLow ? 24 : 28, forecast });
                setLoading(false);
            }, 1500);
            return () => clearTimeout(timer);
        }
    }, [selectedSpot]);

    const filteredSpots = selectedCity?.spots.filter(s => (category === 'all' || s.category === category) && s.name.toLowerCase().includes(search.toLowerCase())) || [];
    const navItems = [{ id: 'dashboard', icon: LayoutDashboard, label: 'Dashboard' }, { id: 'community', icon: UsersRound, label: 'Community' }, { id: 'map', icon: Map, label: 'Live Map' }, { id: 'alerts', icon: Bell, label: 'Alerts', badge: activeAlerts }, { id: 'settings', icon: Settings, label: 'Settings' }];

    return (
        <div style={{ display: 'flex', minHeight: '100vh', background: colors.bg, fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif' }}>
            <style>{`@keyframes pulse { 0%, 100% { opacity: 0.4; transform: scale(1); } 50% { opacity: 1; transform: scale(1.5); } } @keyframes spin { to { transform: rotate(360deg); } }`}</style>

            {/* Sidebar */}
            <aside style={{ width: 260, background: colors.white, borderRight: `1px solid ${colors.slate200}`, display: 'flex', flexDirection: 'column', position: 'fixed', height: '100vh', zIndex: 40, transform: isMobile ? (sidebarOpen ? 'translateX(0)' : 'translateX(-100%)') : 'none', transition: 'transform 0.3s ease' }}>
                <div style={{ padding: 24, borderBottom: `1px solid ${colors.slate200}` }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                        <div style={{ width: 40, height: 40, borderRadius: 10, background: `linear-gradient(135deg, ${colors.orange500}, ${colors.rose600})`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><MapPin size={22} color="white" /></div>
                        <div><h1 style={{ fontSize: 18, fontWeight: 700, color: colors.slate900, margin: 0 }}>Smart Tourism IQ</h1><p style={{ fontSize: 12, color: colors.slate500, margin: 0 }}>India Tourism</p></div>
                    </div>
                </div>
                <nav style={{ flex: 1, padding: 16 }}>
                    {navItems.map(item => (
                        <button key={item.id} onClick={() => { setView(item.id); setSidebarOpen(false); setSelectedCity(null); }} style={{ width: '100%', display: 'flex', alignItems: 'center', gap: 12, padding: '12px 16px', borderRadius: 8, border: 'none', cursor: 'pointer', marginBottom: 4, background: view === item.id ? colors.orange100 : 'transparent', color: view === item.id ? colors.orange500 : colors.slate700 }}>
                            <item.icon size={20} /><span style={{ flex: 1, textAlign: 'left', fontWeight: 500 }}>{item.label}</span>
                            {item.badge && <span style={{ background: colors.rose600, color: 'white', fontSize: 11, padding: '2px 8px', borderRadius: 10, fontWeight: 600 }}>{item.badge}</span>}
                        </button>
                    ))}
                </nav>
                <div style={{ padding: 16, borderTop: `1px solid ${colors.slate200}` }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                        <div style={{ width: 36, height: 36, borderRadius: '50%', background: isRegistered ? avatarColors[userProfile.avatar] : colors.slate200, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                            <User size={18} color={isRegistered ? 'white' : colors.slate400} />
                        </div>
                        <div>
                            <p style={{ fontSize: 14, fontWeight: 500, color: colors.slate900, margin: 0 }}>{isRegistered ? userProfile.name : 'Guest'}</p>
                            <p style={{ fontSize: 12, color: colors.slate500, margin: 0 }}>{isRegistered ? 'Explorer' : 'Not registered'}</p>
                        </div>
                    </div>
                </div>
            </aside>

            {/* Mobile Header */}
            {isMobile && <div style={{ display: 'flex', position: 'fixed', top: 0, left: 0, right: 0, background: 'rgba(255,255,255,0.95)', backdropFilter: 'blur(10px)', padding: '12px 16px', borderBottom: `1px solid ${colors.slate200}`, zIndex: 30, alignItems: 'center', justifyContent: 'space-between' }}>
                <button onClick={() => setSidebarOpen(!sidebarOpen)} style={{ background: 'none', border: 'none', cursor: 'pointer', padding: 8 }}>{sidebarOpen ? <X size={24} color={colors.slate700} /> : <Menu size={24} color={colors.slate700} />}</button>
                <h1 style={{ fontSize: 16, fontWeight: 600, color: colors.slate900, margin: 0 }}>🇮🇳 Smart Tourism IQ</h1><div style={{ width: 40 }} />
            </div>}

            {sidebarOpen && <div onClick={() => setSidebarOpen(false)} style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.3)', zIndex: 35 }} />}

            {/* Main Content */}
            <main style={{ flex: 1, marginLeft: isMobile ? 0 : 260, paddingTop: isMobile ? 60 : 0 }}>
                {view === 'dashboard' && !selectedCity && (
                    <div style={{ padding: 24 }}>
                        <div style={{ marginBottom: 24 }}><h1 style={{ fontSize: 28, fontWeight: 700, color: colors.slate900, margin: 0 }}>🇮🇳 Incredible India Dashboard</h1><p style={{ color: colors.slate500, marginTop: 4 }}>Real-time tourist intelligence across India</p></div>

                        {/* Metrics */}
                        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: 16, marginBottom: 24 }}>
                            {[{ label: 'Total Visitors', value: (totalVisitors / 1000).toFixed(0) + 'K', icon: Users, color: colors.orange500 }, { label: 'Active Alerts', value: activeAlerts, icon: AlertTriangle, color: colors.rose600 }, { label: 'Safest City', value: safestCity.name, icon: Shield, color: colors.emerald500 }].map((m, i) => (
                                <div key={i} style={{ background: colors.white, borderRadius: 12, padding: 20, border: `1px solid ${colors.slate200}` }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}><div style={{ width: 44, height: 44, borderRadius: 10, background: `${m.color}15`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><m.icon size={22} color={m.color} /></div><div><p style={{ fontSize: 12, color: colors.slate500, margin: 0, textTransform: 'uppercase' }}>{m.label}</p><p style={{ fontSize: 24, fontWeight: 700, color: colors.slate900, margin: 0 }}>{m.value}</p></div></div>
                                </div>
                            ))}
                        </div>

                        {/* India Map */}
                        <div style={{ background: colors.white, borderRadius: 16, border: `1px solid ${colors.slate200}`, padding: 24, marginBottom: 24 }}>
                            <h2 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 16px' }}>🗺️ Live India Activity</h2>
                            <div style={{ height: 280, borderRadius: 12, position: 'relative', overflow: 'hidden', background: `linear-gradient(135deg, ${colors.orange100} 0%, ${colors.amber100} 50%, ${colors.emerald100} 100%)`, backgroundImage: `radial-gradient(${colors.slate400} 1px, transparent 1px)`, backgroundSize: '20px 20px' }}>
                                {CITIES.map((city, i) => {
                                    const positions = [[25, 20], [15, 55], [28, 35], [30, 25], [35, 40], [10, 60], [60, 70], [55, 55], [35, 30], [70, 50]];
                                    return <div key={i} style={{ position: 'absolute', left: `${positions[i][0]}%`, top: `${positions[i][1]}%`, display: 'flex', flexDirection: 'column', alignItems: 'center', cursor: 'pointer' }} onClick={() => setSelectedCity(city)}>
                                        <div style={{ width: 14, height: 14, borderRadius: '50%', background: getCrowdColor(city.spots.reduce((s, sp) => s + sp.crowd, 0) / city.spots.length).text, animation: `pulse ${1.5 + Math.random()}s ease-in-out infinite`, boxShadow: `0 0 15px ${getCrowdColor(city.spots.reduce((s, sp) => s + sp.crowd, 0) / city.spots.length).text}60` }} />
                                        <span style={{ fontSize: 10, fontWeight: 600, color: colors.slate700, marginTop: 4, background: 'rgba(255,255,255,0.9)', padding: '2px 6px', borderRadius: 4 }}>{city.name}</span>
                                    </div>;
                                })}
                            </div>
                        </div>

                        {/* City Grid */}
                        <h2 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 16px' }}>Explore Indian Cities</h2>
                        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(240px, 1fr))', gap: 16 }}>
                            {CITIES.map(city => {
                                const avgCrowd = city.spots.reduce((s, sp) => s + sp.crowd, 0) / city.spots.length;
                                const crowdInfo = getCrowdColor(avgCrowd);
                                return (
                                    <div key={city.id} onClick={() => setSelectedCity(city)} style={{ background: colors.white, borderRadius: 16, overflow: 'hidden', cursor: 'pointer', border: `1px solid ${colors.slate200}`, transition: 'transform 0.2s, box-shadow 0.2s' }}>
                                        <div style={{ height: 100, background: `linear-gradient(135deg, ${colors.orange500}, ${colors.rose600})`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 40 }}>{city.emoji}</div>
                                        <div style={{ padding: 16 }}>
                                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start' }}>
                                                <div><h3 style={{ fontSize: 16, fontWeight: 600, color: colors.slate900, margin: 0 }}>{city.name}</h3><p style={{ fontSize: 13, color: colors.slate500, margin: '4px 0 0' }}>{city.country}</p></div>
                                                <span style={{ fontSize: 11, fontWeight: 600, padding: '4px 10px', borderRadius: 20, background: crowdInfo.bg, color: crowdInfo.text }}>{crowdInfo.label}</span>
                                            </div>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 12, color: colors.slate500, fontSize: 13 }}><MapPin size={14} /> {city.spots.length} monuments</div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>

                        {/* Download App Section */}
                        <div style={{ marginTop: 32, background: `linear-gradient(135deg, ${colors.indigo600} 0%, ${colors.violet500} 100%)`, borderRadius: 20, padding: 28, display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 24 }}>
                            <div style={{ flex: 1, minWidth: 250 }}>
                                <h2 style={{ fontSize: 22, fontWeight: 700, color: 'white', margin: '0 0 8px', display: 'flex', alignItems: 'center', gap: 10 }}>
                                    <Smartphone size={26} /> Get Smart Tourism IQ App
                                </h2>
                                <p style={{ color: 'rgba(255,255,255,0.85)', margin: '0 0 20px', fontSize: 14, lineHeight: 1.5 }}>
                                    Download our mobile app for offline access, real-time notifications, and exclusive features!
                                </p>
                                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 12 }}>
                                    <a href="https://play.google.com/store" target="_blank" rel="noopener noreferrer" style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'rgba(0,0,0,0.3)', padding: '10px 16px', borderRadius: 10, color: 'white', textDecoration: 'none', fontSize: 13, fontWeight: 500 }}>
                                        <Download size={18} /> Google Play
                                    </a>
                                    <a href="https://apps.apple.com" target="_blank" rel="noopener noreferrer" style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'rgba(0,0,0,0.3)', padding: '10px 16px', borderRadius: 10, color: 'white', textDecoration: 'none', fontSize: 13, fontWeight: 500 }}>
                                        <Download size={18} /> App Store
                                    </a>
                                    <button onClick={() => { navigator.clipboard.writeText('https://smarttourismiq.app/download'); alert('Link copied! Share with friends 🎉'); }} style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'rgba(255,255,255,0.2)', padding: '10px 16px', borderRadius: 10, color: 'white', border: 'none', cursor: 'pointer', fontSize: 13, fontWeight: 500 }}>
                                        <Share2 size={18} /> Copy Link
                                    </button>
                                </div>
                            </div>
                            <div style={{ background: 'white', borderRadius: 12, padding: 16, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
                                <div style={{ width: 100, height: 100, background: colors.slate100, borderRadius: 8, display: 'flex', alignItems: 'center', justifyContent: 'center', border: `2px solid ${colors.slate200}` }}>
                                    <QrCode size={60} color={colors.slate700} />
                                </div>
                                <span style={{ fontSize: 11, color: colors.slate500, fontWeight: 500 }}>Scan to Download</span>
                            </div>
                        </div>
                    </div>
                )}

                {/* City View */}
                {selectedCity && (
                    <div style={{ padding: 24 }}>
                        <button onClick={() => setSelectedCity(null)} style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'none', border: 'none', color: colors.slate500, cursor: 'pointer', marginBottom: 16, fontSize: 14 }}><ChevronLeft size={18} /> Back to Dashboard</button>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 24 }}><span style={{ fontSize: 48 }}>{selectedCity.emoji}</span><div><h1 style={{ fontSize: 28, fontWeight: 700, color: colors.slate900, margin: 0 }}>{selectedCity.name}</h1><p style={{ fontSize: 14, color: colors.slate500, margin: '4px 0 0' }}>{selectedCity.country} • {selectedCity.spots.length} attractions</p></div></div>

                        <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap', marginBottom: 24 }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 8, background: colors.white, border: `1px solid ${colors.slate200}`, borderRadius: 10, padding: '8px 16px', flex: 1, minWidth: 200, maxWidth: 300 }}><Search size={18} color={colors.slate400} /><input value={search} onChange={e => setSearch(e.target.value)} placeholder="Search monuments..." style={{ border: 'none', outline: 'none', flex: 1, fontSize: 14 }} /></div>
                            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>{CATEGORIES.map(c => (<button key={c.id} onClick={() => setCategory(c.id)} style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '8px 14px', borderRadius: 10, border: 'none', cursor: 'pointer', fontSize: 13, fontWeight: 500, background: category === c.id ? colors.orange500 : colors.white, color: category === c.id ? 'white' : colors.slate700 }}><c.icon size={16} /> {c.name}</button>))}</div>
                        </div>

                        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: 16 }}>
                            {filteredSpots.map(spot => {
                                const crowdInfo = getCrowdColor(spot.crowd);
                                const CategoryIcon = CATEGORIES.find(c => c.id === spot.category)?.icon || Filter;
                                return (
                                    <div key={spot.id} onClick={() => setSelectedSpot(spot)} style={{ background: colors.white, borderRadius: 14, padding: 20, cursor: 'pointer', border: `1px solid ${colors.slate200}` }}>
                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', marginBottom: 12 }}><div style={{ width: 44, height: 44, borderRadius: 10, background: colors.orange100, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><CategoryIcon size={22} color={colors.orange500} /></div><span style={{ fontSize: 11, fontWeight: 600, padding: '4px 10px', borderRadius: 20, background: crowdInfo.bg, color: crowdInfo.text }}>{spot.crowd}%</span></div>
                                        <h3 style={{ fontSize: 16, fontWeight: 600, color: colors.slate900, margin: '0 0 6px' }}>{spot.name}</h3>
                                        <p style={{ fontSize: 13, color: colors.slate500, margin: '0 0 12px' }}>{spot.desc}</p>
                                        <div style={{ display: 'flex', alignItems: 'center', gap: 12, fontSize: 12, color: colors.slate400 }}><span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><Clock size={14} /> {spot.hours}</span><span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><Ticket size={14} /> {spot.price}</span></div>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                )}

                {view === 'alerts' && <div style={{ padding: 24 }}><h1 style={{ fontSize: 24, fontWeight: 700, color: colors.slate900, margin: '0 0 24px' }}>🚨 Active Alerts</h1><div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>{CITIES.flatMap(c => c.spots.filter(s => s.crowd >= 80).map(s => ({ ...s, city: c.name }))).map((s, i) => (<div key={i} style={{ background: colors.white, borderRadius: 12, padding: 16, border: `1px solid ${colors.rose100}`, borderLeft: `4px solid ${colors.rose600}` }}><div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}><div><h3 style={{ fontSize: 15, fontWeight: 600, color: colors.slate900, margin: 0 }}>{s.name}</h3><p style={{ fontSize: 13, color: colors.slate500, margin: '4px 0 0' }}>{s.city}</p></div><span style={{ fontSize: 11, fontWeight: 600, padding: '4px 12px', borderRadius: 20, background: s.crowd >= 86 ? colors.purple100 : colors.rose100, color: s.crowd >= 86 ? colors.purple600 : colors.rose600 }}>{s.crowd}%</span></div></div>))}</div></div>}

                {/* Community Page */}
                {view === 'community' && <div style={{ padding: 24 }}>
                    <h1 style={{ fontSize: 28, fontWeight: 700, color: colors.slate900, margin: '0 0 8px' }}>🤝 Community Hub</h1>
                    <p style={{ color: colors.slate500, margin: '0 0 24px' }}>Connect with fellow travelers and join exciting meetups!</p>

                    {/* Community Stats */}
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: 16, marginBottom: 32 }}>
                        {[{ label: 'Active Groups', value: '24', icon: UsersRound, color: colors.orange500 }, { label: 'Upcoming Events', value: '12', icon: Calendar, color: colors.violet500 }, { label: 'Members', value: '2.4K', icon: Globe, color: colors.emerald500 }].map((s, i) => (
                            <div key={i} style={{ background: colors.white, borderRadius: 12, padding: 16, border: `1px solid ${colors.slate200}` }}>
                                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                                    <div style={{ width: 40, height: 40, borderRadius: 10, background: `${s.color}15`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><s.icon size={20} color={s.color} /></div>
                                    <div><p style={{ fontSize: 20, fontWeight: 700, color: colors.slate900, margin: 0 }}>{s.value}</p><p style={{ fontSize: 12, color: colors.slate500, margin: 0 }}>{s.label}</p></div>
                                </div>
                            </div>
                        ))}
                    </div>

                    {/* Travel Groups */}
                    <h2 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 16px', display: 'flex', alignItems: 'center', gap: 8 }}><UsersRound size={20} /> Travel Communities</h2>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: 16, marginBottom: 32 }}>
                        {[
                            { name: 'Solo Travelers India', members: 856, desc: 'Safe travels for solo explorers', emoji: '🎒', category: 'Solo', verified: true },
                            { name: 'Heritage Walkers', members: 1243, desc: 'Discover India\'s rich history together', emoji: '🏛️', category: 'Heritage', verified: true },
                            { name: 'Temple Yatra Group', members: 2105, desc: 'Spiritual journeys across holy sites', emoji: '🛕', category: 'Spiritual', verified: true },
                            { name: 'Photography Travelers', members: 678, desc: 'Capture beautiful moments together', emoji: '📸', category: 'Creative', verified: false },
                            { name: 'Women Travelers India', members: 1567, desc: 'Safe & empowering travel for women', emoji: '👩‍👩‍👧', category: 'Women Only', verified: true },
                            { name: 'Budget Backpackers', members: 932, desc: 'Explore India on a budget', emoji: '💰', category: 'Budget', verified: false },
                            { name: 'Nature & Wildlife', members: 445, desc: 'Explore forests, parks & wildlife', emoji: '🦁', category: 'Nature', verified: true },
                            { name: 'Senior Citizens Travel', members: 312, desc: 'Comfortable trips for elders', emoji: '👴', category: 'Seniors', verified: true }
                        ].map((group, i) => (
                            <div key={i} style={{ background: colors.white, borderRadius: 16, padding: 20, border: `1px solid ${colors.slate200}`, transition: 'transform 0.2s' }}>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', marginBottom: 12 }}>
                                    <div style={{ fontSize: 36 }}>{group.emoji}</div>
                                    {group.verified && <div style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 11, color: colors.emerald500, background: colors.emerald100, padding: '4px 8px', borderRadius: 20 }}><Shield size={12} /> Verified</div>}
                                </div>
                                <h3 style={{ fontSize: 16, fontWeight: 600, color: colors.slate900, margin: '0 0 4px' }}>{group.name}</h3>
                                <p style={{ fontSize: 13, color: colors.slate500, margin: '0 0 12px' }}>{group.desc}</p>
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                    <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, color: colors.slate400 }}><Users size={14} /> {group.members} members</div>
                                    <button style={{ padding: '8px 16px', borderRadius: 8, border: 'none', background: colors.orange500, color: 'white', fontSize: 13, fontWeight: 500, cursor: 'pointer' }}>Join</button>
                                </div>
                            </div>
                        ))}
                    </div>

                    {/* Upcoming Meetups */}
                    <h2 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 16px', display: 'flex', alignItems: 'center', gap: 8 }}><Calendar size={20} /> Upcoming Meetups</h2>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                        {[
                            { title: 'Sunrise at Taj Mahal', date: 'Tomorrow, 5:30 AM', location: 'Agra', attendees: 18, host: 'Heritage Walkers', emoji: '🌅' },
                            { title: 'Ganga Aarti Experience', date: 'Feb 10, 6:00 PM', location: 'Varanasi', attendees: 32, host: 'Temple Yatra Group', emoji: '🪔' },
                            { title: 'Street Food Walk', date: 'Feb 11, 4:00 PM', location: 'Delhi - Chandni Chowk', attendees: 15, host: 'Budget Backpackers', emoji: '🍜' },
                            { title: 'Hawa Mahal Photography', date: 'Feb 12, 7:00 AM', location: 'Jaipur', attendees: 24, host: 'Photography Travelers', emoji: '📷' },
                            { title: 'Beach Cleanup & Sunset', date: 'Feb 14, 4:30 PM', location: 'Goa - Calangute', attendees: 42, host: 'Nature & Wildlife', emoji: '🏖️' },
                            { title: 'Women\'s Heritage Walk', date: 'Feb 15, 10:00 AM', location: 'Mumbai - Colaba', attendees: 28, host: 'Women Travelers India', emoji: '👩‍👩‍👧' }
                        ].map((event, i) => (
                            <div key={i} style={{ background: colors.white, borderRadius: 14, padding: 16, border: `1px solid ${colors.slate200}`, display: 'flex', alignItems: 'center', gap: 16 }}>
                                <div style={{ width: 56, height: 56, borderRadius: 12, background: colors.orange100, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 28 }}>{event.emoji}</div>
                                <div style={{ flex: 1 }}>
                                    <h3 style={{ fontSize: 15, fontWeight: 600, color: colors.slate900, margin: '0 0 4px' }}>{event.title}</h3>
                                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 12, fontSize: 12, color: colors.slate500 }}>
                                        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><Calendar size={12} /> {event.date}</span>
                                        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><MapPin size={12} /> {event.location}</span>
                                        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><Users size={12} /> {event.attendees} going</span>
                                    </div>
                                    <p style={{ fontSize: 11, color: colors.slate400, margin: '4px 0 0' }}>Hosted by {event.host}</p>
                                </div>
                                <button style={{ padding: '10px 20px', borderRadius: 8, border: 'none', background: colors.orange500, color: 'white', fontSize: 13, fontWeight: 500, cursor: 'pointer', whiteSpace: 'nowrap' }}>RSVP</button>
                            </div>
                        ))}
                    </div>

                    {/* Create Group CTA */}
                    <div style={{ marginTop: 32, background: `linear-gradient(135deg, ${colors.orange500}, ${colors.rose600})`, borderRadius: 16, padding: 24, textAlign: 'center' }}>
                        <h3 style={{ fontSize: 20, fontWeight: 600, color: 'white', margin: '0 0 8px' }}>Can't find your community?</h3>
                        <p style={{ color: 'rgba(255,255,255,0.9)', margin: '0 0 16px', fontSize: 14 }}>Start your own travel group and connect with like-minded explorers!</p>
                        <button style={{ padding: '12px 28px', borderRadius: 10, border: '2px solid white', background: 'transparent', color: 'white', fontSize: 14, fontWeight: 600, cursor: 'pointer' }}>+ Create New Group</button>
                    </div>
                </div>}

                {view === 'settings' && <div style={{ padding: 24 }}>
                    <h1 style={{ fontSize: 24, fontWeight: 700, color: colors.slate900, margin: '0 0 24px' }}>⚙️ Settings</h1>

                    {/* User Profile Section */}
                    <div style={{ background: colors.white, borderRadius: 16, border: `1px solid ${colors.slate200}`, padding: 24, marginBottom: 20 }}>
                        <h2 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 20px', display: 'flex', alignItems: 'center', gap: 8 }}><User size={20} /> User Profile</h2>

                        {!isRegistered ? (
                            /* Guest User - Show Register Button */
                            !showRegister ? (
                                <div style={{ textAlign: 'center', padding: 32 }}>
                                    <div style={{ width: 80, height: 80, borderRadius: '50%', background: colors.slate200, display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 16px' }}>
                                        <User size={40} color={colors.slate400} />
                                    </div>
                                    <h3 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 8px' }}>Guest User</h3>
                                    <p style={{ color: colors.slate500, margin: '0 0 24px', fontSize: 14 }}>Register to save your preferences and get personalized recommendations</p>
                                    <button onClick={() => setShowRegister(true)} style={{ background: colors.orange500, color: 'white', border: 'none', padding: '14px 32px', borderRadius: 10, fontSize: 16, fontWeight: 600, cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 8 }}>
                                        <User size={18} /> Register Now
                                    </button>
                                </div>
                            ) : (
                                /* Registration Form */
                                <div>
                                    <h3 style={{ fontSize: 16, fontWeight: 600, color: colors.slate900, margin: '0 0 20px' }}>Create Your Profile</h3>

                                    {/* Avatar Selection */}
                                    <div style={{ marginBottom: 24 }}>
                                        <label style={{ fontSize: 13, fontWeight: 500, color: colors.slate700, marginBottom: 12, display: 'block' }}>Choose Avatar Color</label>
                                        <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
                                            {avatarColors.map((color, i) => (
                                                <div key={i} onClick={() => setUserProfile({ ...userProfile, avatar: i })} style={{ width: 50, height: 50, borderRadius: '50%', background: color, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', border: userProfile.avatar === i ? '3px solid ' + colors.slate900 : '3px solid transparent', transition: 'all 0.2s' }}>
                                                    <User size={24} color="white" />
                                                    {userProfile.avatar === i && <Check size={16} color="white" style={{ position: 'absolute' }} />}
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    {/* Form Fields */}
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
                                        <div>
                                            <label style={{ fontSize: 13, fontWeight: 500, color: colors.slate700, marginBottom: 6, display: 'block' }}>Full Name *</label>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: colors.slate100, borderRadius: 10, padding: '12px 16px' }}>
                                                <User size={18} color={colors.slate400} />
                                                <input value={userProfile.name} onChange={e => setUserProfile({ ...userProfile, name: e.target.value })} placeholder="Enter your name" style={{ border: 'none', background: 'transparent', outline: 'none', flex: 1, fontSize: 14, color: colors.slate900 }} />
                                            </div>
                                        </div>
                                        <div>
                                            <label style={{ fontSize: 13, fontWeight: 500, color: colors.slate700, marginBottom: 6, display: 'block' }}>Email Address *</label>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: colors.slate100, borderRadius: 10, padding: '12px 16px' }}>
                                                <Mail size={18} color={colors.slate400} />
                                                <input type="email" value={userProfile.email} onChange={e => setUserProfile({ ...userProfile, email: e.target.value })} placeholder="Enter your email" style={{ border: 'none', background: 'transparent', outline: 'none', flex: 1, fontSize: 14, color: colors.slate900 }} />
                                            </div>
                                        </div>
                                        <div>
                                            <label style={{ fontSize: 13, fontWeight: 500, color: colors.slate700, marginBottom: 6, display: 'block' }}>Phone Number</label>
                                            <div style={{ display: 'flex', alignItems: 'center', gap: 10, background: colors.slate100, borderRadius: 10, padding: '12px 16px' }}>
                                                <Phone size={18} color={colors.slate400} />
                                                <input value={userProfile.phone} onChange={e => setUserProfile({ ...userProfile, phone: e.target.value })} placeholder="+91 XXXXX XXXXX" style={{ border: 'none', background: 'transparent', outline: 'none', flex: 1, fontSize: 14, color: colors.slate900 }} />
                                            </div>
                                        </div>
                                    </div>

                                    {/* Buttons */}
                                    <div style={{ display: 'flex', gap: 12, marginTop: 24 }}>
                                        <button onClick={() => setShowRegister(false)} style={{ flex: 1, padding: 14, borderRadius: 10, border: `1px solid ${colors.slate200}`, background: 'white', fontSize: 14, fontWeight: 500, cursor: 'pointer', color: colors.slate700 }}>Cancel</button>
                                        <button onClick={() => { if (userProfile.name && userProfile.email) { setIsRegistered(true); setShowRegister(false); } }} style={{ flex: 1, padding: 14, borderRadius: 10, border: 'none', background: userProfile.name && userProfile.email ? colors.orange500 : colors.slate300, color: 'white', fontSize: 14, fontWeight: 600, cursor: userProfile.name && userProfile.email ? 'pointer' : 'not-allowed' }}>Create Profile</button>
                                    </div>
                                </div>
                            )
                        ) : (
                            /* Registered User Profile */
                            <div>
                                <div style={{ display: 'flex', alignItems: 'center', gap: 20, marginBottom: 24, padding: 20, background: colors.slate100, borderRadius: 12 }}>
                                    <div style={{ width: 70, height: 70, borderRadius: '50%', background: avatarColors[userProfile.avatar], display: 'flex', alignItems: 'center', justifyContent: 'center', position: 'relative' }}>
                                        <User size={32} color="white" />
                                        <button style={{ position: 'absolute', bottom: -4, right: -4, width: 28, height: 28, borderRadius: '50%', background: colors.white, border: `2px solid ${colors.slate200}`, display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' }}>
                                            <Camera size={14} color={colors.slate600} />
                                        </button>
                                    </div>
                                    <div style={{ flex: 1 }}>
                                        <h3 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: 0 }}>{userProfile.name}</h3>
                                        <p style={{ fontSize: 13, color: colors.slate500, margin: '4px 0 0' }}>{userProfile.email}</p>
                                        {userProfile.phone && <p style={{ fontSize: 13, color: colors.slate500, margin: '2px 0 0' }}>{userProfile.phone}</p>}
                                    </div>
                                    <button style={{ padding: '10px 16px', borderRadius: 8, border: `1px solid ${colors.slate200}`, background: 'white', display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer', fontSize: 13, fontWeight: 500, color: colors.slate700 }}>
                                        <Edit2 size={14} /> Edit
                                    </button>
                                </div>

                                {/* Avatar Options */}
                                <div style={{ marginBottom: 24 }}>
                                    <label style={{ fontSize: 13, fontWeight: 500, color: colors.slate700, marginBottom: 12, display: 'block' }}>Change Avatar Color</label>
                                    <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                                        {avatarColors.map((color, i) => (
                                            <div key={i} onClick={() => setUserProfile({ ...userProfile, avatar: i })} style={{ width: 44, height: 44, borderRadius: '50%', background: color, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', border: userProfile.avatar === i ? '3px solid ' + colors.slate900 : '3px solid transparent', transition: 'all 0.2s' }}>
                                                {userProfile.avatar === i && <Check size={18} color="white" />}
                                            </div>
                                        ))}
                                    </div>
                                </div>

                                {/* Logout Button */}
                                <button onClick={() => { setIsRegistered(false); setUserProfile({ name: '', email: '', phone: '', avatar: 0 }); }} style={{ width: '100%', padding: 14, borderRadius: 10, border: `1px solid ${colors.rose100}`, background: colors.rose100, color: colors.rose600, fontSize: 14, fontWeight: 600, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8 }}>
                                    <LogOut size={18} /> Sign Out
                                </button>
                            </div>
                        )}
                    </div>

                    {/* Other Settings */}
                    <div style={{ background: colors.white, borderRadius: 16, border: `1px solid ${colors.slate200}`, padding: 24 }}>
                        <h2 style={{ fontSize: 18, fontWeight: 600, color: colors.slate900, margin: '0 0 16px' }}>Preferences</h2>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                            {/* Push Notifications */}
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: 16, background: colors.slate100, borderRadius: 10 }}>
                                <div><p style={{ fontSize: 14, fontWeight: 500, color: colors.slate900, margin: 0 }}>Push Notifications</p><p style={{ fontSize: 12, color: colors.slate500, margin: '2px 0 0' }}>Get alerts for crowd surges</p></div>
                                <div style={{ width: 44, height: 24, borderRadius: 12, background: colors.orange500, cursor: 'pointer', position: 'relative' }}>
                                    <div style={{ width: 20, height: 20, borderRadius: '50%', background: 'white', position: 'absolute', top: 2, left: 22, transition: 'left 0.2s' }} />
                                </div>
                            </div>
                            {/* Location Access */}
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: 16, background: colors.slate100, borderRadius: 10 }}>
                                <div><p style={{ fontSize: 14, fontWeight: 500, color: colors.slate900, margin: 0 }}>Location Access</p><p style={{ fontSize: 12, color: colors.slate500, margin: '2px 0 0' }}>Enable for nearby recommendations</p></div>
                                <div style={{ width: 44, height: 24, borderRadius: 12, background: colors.slate300, cursor: 'pointer', position: 'relative' }}>
                                    <div style={{ width: 20, height: 20, borderRadius: '50%', background: 'white', position: 'absolute', top: 2, left: 2, transition: 'left 0.2s' }} />
                                </div>
                            </div>
                            {/* Dark Mode - FUNCTIONAL */}
                            <div onClick={() => setDarkMode(!darkMode)} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: 16, background: colors.slate100, borderRadius: 10, cursor: 'pointer' }}>
                                <div><p style={{ fontSize: 14, fontWeight: 500, color: colors.slate900, margin: 0 }}>🌙 Dark Mode</p><p style={{ fontSize: 12, color: colors.slate500, margin: '2px 0 0' }}>{darkMode ? 'Currently ON - Click to disable' : 'Currently OFF - Click to enable'}</p></div>
                                <div style={{ width: 44, height: 24, borderRadius: 12, background: darkMode ? colors.orange500 : colors.slate300, cursor: 'pointer', position: 'relative', transition: 'background 0.3s' }}>
                                    <div style={{ width: 20, height: 20, borderRadius: '50%', background: 'white', position: 'absolute', top: 2, left: darkMode ? 22 : 2, transition: 'left 0.2s' }} />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>}
                {view === 'map' && <div style={{ padding: 24 }}><h1 style={{ fontSize: 24, fontWeight: 700, color: colors.slate900, margin: '0 0 24px' }}>🗺️ India Live Map</h1><div style={{ background: colors.white, borderRadius: 16, border: `1px solid ${colors.slate200}`, padding: 24, height: 500, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><div style={{ textAlign: 'center', color: colors.slate500 }}><Map size={48} style={{ marginBottom: 16 }} /><p>Interactive India map coming soon</p></div></div></div>}
            </main >

            {/* Spot Slide-over */}
            {
                selectedSpot && (<>
                    <div onClick={() => setSelectedSpot(null)} style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)', zIndex: 50 }} />
                    <div style={{ position: 'fixed', top: 0, right: 0, bottom: 0, width: '100%', maxWidth: 480, background: colors.white, zIndex: 51, overflowY: 'auto', boxShadow: '-10px 0 40px rgba(0,0,0,0.1)' }}>
                        <div style={{ padding: 24, borderBottom: `1px solid ${colors.slate200}`, background: 'rgba(255,255,255,0.95)', backdropFilter: 'blur(10px)', position: 'sticky', top: 0 }}>
                            <button onClick={() => setSelectedSpot(null)} style={{ background: colors.slate100, border: 'none', borderRadius: 8, padding: 8, cursor: 'pointer', marginBottom: 16 }}><X size={20} color={colors.slate700} /></button>
                            <h2 style={{ fontSize: 22, fontWeight: 700, color: colors.slate900, margin: 0 }}>{selectedSpot.name}</h2>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 8 }}><span style={{ fontSize: 12, fontWeight: 600, padding: '4px 12px', borderRadius: 20, background: getCrowdColor(selectedSpot.crowd).bg, color: getCrowdColor(selectedSpot.crowd).text }}>{selectedSpot.crowd}% Capacity</span></div>
                        </div>
                        <div style={{ padding: 24 }}>
                            {loading ? (<div style={{ textAlign: 'center', padding: 48 }}><div style={{ width: 40, height: 40, border: `3px solid ${colors.slate200}`, borderTopColor: colors.orange500, borderRadius: '50%', animation: 'spin 1s linear infinite', margin: '0 auto 16px' }} /><p style={{ color: colors.slate500 }}>Fetching Telemetry...</p></div>
                            ) : telemetry && (<>
                                <div style={{ marginBottom: 24 }}><h3 style={{ fontSize: 14, fontWeight: 600, color: colors.slate900, margin: '0 0 16px' }}>12-Hour Crowd Forecast</h3><div style={{ display: 'flex', alignItems: 'flex-end', gap: 6, height: 120, padding: 16, background: colors.slate100, borderRadius: 12 }}>{telemetry.forecast.map((val, i) => (<div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}><div style={{ width: '100%', borderRadius: 4, height: val, maxHeight: 80, background: val > 60 ? colors.rose600 : val > 40 ? colors.amber500 : colors.emerald500 }} /><span style={{ fontSize: 9, color: colors.slate400 }}>{i + 1}h</span></div>))}</div><div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 8, marginTop: 12 }}>{selectedSpot.crowd > 80 ? <TrendingDown size={16} color={colors.emerald500} /> : <TrendingUp size={16} color={colors.rose600} />}<span style={{ fontSize: 13, color: colors.slate500 }}>Trend: {selectedSpot.crowd > 80 ? 'Decreasing' : selectedSpot.crowd < 30 ? 'Increasing' : 'Stable'}</span></div></div>
                                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>{[{ label: 'Traffic', value: telemetry.traffic, icon: Car, color: telemetry.traffic === 'Gridlock' ? colors.rose600 : colors.emerald500 }, { label: 'Parking', value: `${telemetry.parking}% Free`, icon: ParkingCircle, color: telemetry.parking < 20 ? colors.rose600 : colors.emerald500 }, { label: 'Weather', value: telemetry.weather.charAt(0).toUpperCase() + telemetry.weather.slice(1), icon: telemetry.weather === 'sunny' ? Sun : telemetry.weather === 'rainy' ? CloudRain : Cloud, color: colors.indigo600 }, { label: 'Temperature', value: `${telemetry.temp}°C`, icon: Thermometer, color: colors.amber500 }].map((w, i) => (<div key={i} style={{ background: colors.slate100, borderRadius: 12, padding: 16 }}><div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}><w.icon size={18} color={w.color} /><span style={{ fontSize: 12, color: colors.slate500 }}>{w.label}</span></div><p style={{ fontSize: 16, fontWeight: 600, color: colors.slate900, margin: 0 }}>{w.value}</p></div>))}</div>
                                <div style={{ marginTop: 24, padding: 16, background: colors.slate100, borderRadius: 12 }}><div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 12 }}><span style={{ fontSize: 13, color: colors.slate500 }}>Hours</span><span style={{ fontSize: 13, fontWeight: 500, color: colors.slate700 }}>{selectedSpot.hours}</span></div><div style={{ display: 'flex', justifyContent: 'space-between' }}><span style={{ fontSize: 13, color: colors.slate500 }}>Entry Fee</span><span style={{ fontSize: 13, fontWeight: 500, color: colors.slate700 }}>{selectedSpot.price}</span></div></div>
                                <div style={{ marginTop: 24, display: 'flex', gap: 12 }}><button style={{ flex: 1, padding: 14, borderRadius: 10, border: 'none', background: colors.orange500, color: 'white', fontWeight: 600, cursor: 'pointer' }}>Get Directions</button><button style={{ padding: 14, borderRadius: 10, border: `1px solid ${colors.slate200}`, background: 'white', cursor: 'pointer' }}><Bell size={20} color={colors.slate700} /></button></div>
                            </>)}
                        </div>
                    </div>
                </>)
            }

            {/* Chatbot Floating Button */}
            <button onClick={() => setChatOpen(!chatOpen)} style={{ position: 'fixed', bottom: 24, right: 24, width: 60, height: 60, borderRadius: '50%', background: `linear-gradient(135deg, ${colors.orange500}, ${colors.rose600})`, border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 4px 20px rgba(249, 115, 22, 0.4)', zIndex: 100, transition: 'transform 0.3s' }}>
                {chatOpen ? <X size={28} color="white" /> : <MessageCircle size={28} color="white" />}
            </button>

            {/* Chat Panel */}
            {
                chatOpen && (
                    <div style={{ position: 'fixed', bottom: 100, right: 24, width: isMobile ? 'calc(100% - 48px)' : 380, height: 500, background: colors.white, borderRadius: 20, boxShadow: '0 10px 40px rgba(0,0,0,0.2)', zIndex: 99, display: 'flex', flexDirection: 'column', overflow: 'hidden', border: `1px solid ${colors.slate200}` }}>
                        {/* Chat Header */}
                        <div style={{ padding: 16, background: `linear-gradient(135deg, ${colors.orange500}, ${colors.rose600})`, color: 'white' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                                <div style={{ width: 44, height: 44, borderRadius: '50%', background: 'rgba(255,255,255,0.2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                                    <Smile size={26} color="white" />
                                </div>
                                <div>
                                    <h3 style={{ margin: 0, fontSize: 16, fontWeight: 600 }}>TourBot 🤖</h3>
                                    <p style={{ margin: 0, fontSize: 12, opacity: 0.9 }}>Your friendly travel companion</p>
                                </div>
                            </div>
                        </div>

                        {/* Messages */}
                        <div style={{ flex: 1, overflowY: 'auto', padding: 16, display: 'flex', flexDirection: 'column', gap: 12, background: colors.bg }}>
                            {chatMessages.map((msg, i) => (
                                <div key={i} style={{ display: 'flex', justifyContent: msg.from === 'user' ? 'flex-end' : 'flex-start' }}>
                                    <div style={{ maxWidth: '85%', padding: 12, borderRadius: msg.from === 'user' ? '16px 16px 4px 16px' : '16px 16px 16px 4px', background: msg.from === 'user' ? colors.orange500 : colors.white, color: msg.from === 'user' ? 'white' : colors.slate900, fontSize: 14, lineHeight: 1.5, whiteSpace: 'pre-line', boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
                                        {msg.text}
                                    </div>
                                </div>
                            ))}
                        </div>

                        {/* Quick Suggestions */}
                        <div style={{ padding: '8px 16px', display: 'flex', gap: 8, flexWrap: 'wrap', borderTop: `1px solid ${colors.slate200}`, background: colors.white }}>
                            {['Peace 🕊️', 'Nature 🌿', 'Temple 🛕', 'Safe spots 🛡️'].map((q, i) => (
                                <button key={i} onClick={() => { setChatInput(q); }} style={{ padding: '6px 12px', borderRadius: 20, border: `1px solid ${colors.slate200}`, background: colors.slate100, fontSize: 12, cursor: 'pointer', color: colors.slate700 }}>{q}</button>
                            ))}
                        </div>

                        {/* Input */}
                        <div style={{ padding: 12, borderTop: `1px solid ${colors.slate200}`, display: 'flex', gap: 8, background: colors.white }}>
                            <input value={chatInput} onChange={e => setChatInput(e.target.value)} onKeyDown={e => e.key === 'Enter' && sendMessage()} placeholder="How are you feeling today?" style={{ flex: 1, padding: '12px 16px', borderRadius: 24, border: `1px solid ${colors.slate200}`, outline: 'none', fontSize: 14, background: colors.slate100, color: colors.slate900 }} />
                            <button onClick={sendMessage} style={{ width: 44, height: 44, borderRadius: '50%', border: 'none', background: colors.orange500, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                                <Send size={20} color="white" />
                            </button>
                        </div>
                    </div>
                )
            }
        </div >
    );
}
