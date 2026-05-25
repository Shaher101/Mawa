import { useState, useEffect } from 'react';
import { ArrowLeft, Plus, Home, FileText, Bell, Users, Building2, ChevronRight } from 'lucide-react';
import { Listing, Request } from '../../lib/types';
import { Button } from '../../ui/button';

interface OwnerDashboardProps {
  listings: Listing[];
  requests: Request[];
  onAddListing: () => void;
  onManageListings: () => void;
  onViewRequests: () => void;
  onBack?: () => void;
  userName: string;
}

export function OwnerDashboard({ 
  listings, 
  requests, 
  onAddListing,
  onManageListings,
  onViewRequests,
  onBack,
  userName 
}: OwnerDashboardProps) {
  const [greeting, setGreeting] = useState('');
  const [showFloatingButton, setShowFloatingButton] = useState(true);

  useEffect(() => {
    const hour = new Date().getHours();
    if (hour < 12) setGreeting('Good Morning');
    else if (hour < 18) setGreeting('Good Afternoon');
    else setGreeting('Good Evening');

    // Hide floating button on scroll down
    let lastScrollY = window.scrollY;
    const handleScroll = () => {
      if (window.scrollY > lastScrollY && window.scrollY > 100) {
        setShowFloatingButton(false);
      } else {
        setShowFloatingButton(true);
      }
      lastScrollY = window.scrollY;
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const totalListings = listings.length;
  const totalStudents = listings.reduce((total, listing) => {
    return total + (listing.roommatePreferences?.currentRoommates || 0);
  }, 0);
  const pendingRequests = requests.filter(r => r.status === 'pending').length;

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      
      {/* ============================================ */}
      {/* HEADER */}
      {/* ============================================ */}
      <div className="bg-[#022B60] px-6 pt-12 pb-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            {onBack && (
              <button onClick={onBack} className="text-white/70">
                <ArrowLeft className="w-5 h-5" />
              </button>
            )}
            <div>
              <p className="text-white/60 text-sm">{greeting},</p>
              <h1 className="text-xl font-semibold text-white">{userName}</h1>
              <div className="flex items-center gap-1.5 mt-1">
                <div className="w-1.5 h-1.5 bg-green-400 rounded-full" />
                <span className="text-white/50 text-xs">Verified Owner</span>
              </div>
            </div>
          </div>
          <button className="w-9 h-9 rounded-full bg-white/10 flex items-center justify-center">
            <Bell className="w-4 h-4 text-white/70" />
          </button>
        </div>
      </div>

      {/* ============================================ */}
      {/* STATS - كارت واحد */}
      {/* ============================================ */}
      <div className="px-6 mt-6">
        <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
          <div className="flex justify-between items-center">
            <div>
              <p className="text-gray-400 text-xs mb-1">Your Properties</p>
              <p className="text-2xl font-semibold text-gray-800">{totalListings}</p>
              <p className="text-xs text-gray-400 mt-1">Listings</p>
            </div>
            <div className="h-10 w-px bg-gray-100" />
            <div>
              <p className="text-gray-400 text-xs mb-1">Students Living</p>
              <p className="text-2xl font-semibold text-gray-800">{totalStudents}</p>
              <p className="text-xs text-gray-400 mt-1">Active</p>
            </div>
            <div className="h-10 w-px bg-gray-100" />
            <div>
              <p className="text-gray-400 text-xs mb-1">Pending</p>
              <p className="text-2xl font-semibold text-orange-500">{pendingRequests}</p>
              <p className="text-xs text-gray-400 mt-1">Requests</p>
            </div>
          </div>
        </div>
      </div>

      {/* ============================================ */}
      {/* QUICK ACTIONS - Row واحدة */}
      {/* ============================================ */}
      <div className="px-6 mt-8">
        <div className="flex gap-4">
          <button
            onClick={onAddListing}
            className="flex-1 bg-white rounded-2xl p-4 border border-gray-100 flex flex-col items-center gap-2 hover:bg-gray-50 transition-all"
          >
            <div className="w-10 h-10 rounded-xl bg-[#FFF1E8] flex items-center justify-center">
              <Plus className="w-5 h-5 text-[#FF751F]" />
            </div>
            <span className="text-xs font-medium text-gray-700">Add Listing</span>
          </button>

          <button
            onClick={onManageListings}
            className="flex-1 bg-white rounded-2xl p-4 border border-gray-100 flex flex-col items-center gap-2 hover:bg-gray-50 transition-all"
          >
            <div className="w-10 h-10 rounded-xl bg-gray-100 flex items-center justify-center">
              <Home className="w-5 h-5 text-gray-500" />
            </div>
            <span className="text-xs font-medium text-gray-700">Listings</span>
          </button>

          <button
            onClick={onViewRequests}
            className="flex-1 bg-white rounded-2xl p-4 border border-gray-100 flex flex-col items-center gap-2 hover:bg-gray-50 transition-all relative"
          >
            <div className="w-10 h-10 rounded-xl bg-gray-100 flex items-center justify-center relative">
              <FileText className="w-5 h-5 text-gray-500" />
              {pendingRequests > 0 && (
                <span className="absolute -top-1 -right-1 w-4 h-4 bg-[#FF751F] text-white rounded-full text-[10px] flex items-center justify-center">
                  {pendingRequests}
                </span>
              )}
            </div>
            <span className="text-xs font-medium text-gray-700">Requests</span>
          </button>
        </div>
      </div>

      {/* ============================================ */}
      {/* YOUR LISTINGS */}
      {/* ============================================ */}
      {listings.length > 0 && (
        <div className="px-6 mt-8">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-base font-semibold text-gray-800">Your Listings</h2>
            {listings.length > 3 && (
              <button className="text-xs text-[#FF751F]">See All →</button>
            )}
          </div>

          <div className="space-y-3">
            {listings.slice(0, 3).map((listing) => {
              const currentOccupancy = listing.roommatePreferences?.currentRoommates || 0;
              const maxOccupancy = listing.roommatePreferences?.maxRoommates || 1;
              const occupancyPercent = (currentOccupancy / maxOccupancy) * 100;
              const isActive = listing.status === 'active' || !listing.status;
              
              return (
                <div key={listing.id} className="bg-white rounded-2xl p-4 border border-gray-100">
                  <div className="flex gap-3">
                    <div className="w-20 h-20 rounded-xl overflow-hidden shrink-0 bg-gray-100">
                      <img
                        src={listing.images?.[0] || 'https://placehold.co/400x300/EAEAEA/999?text=No+Image'}
                        alt={listing.title}
                        className="w-full h-full object-cover"
                      />
                    </div>
                    
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between">
                        <div>
                          <h3 className="font-medium text-gray-800 text-sm line-clamp-1">
                            {listing.title}
                          </h3>
                          <p className="text-xs text-gray-400 mt-0.5">
                            {listing.location?.address?.split(',')[0] || 'Location'}
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="font-semibold text-[#FF751F] text-sm">
                            {listing.pricePerPerson?.toLocaleString()} EGP
                          </p>
                          <p className="text-[10px] text-gray-400">/bed</p>
                        </div>
                      </div>

                      <div className="flex items-center justify-between mt-2">
                        <div className="flex items-center gap-2">
                          <span className="text-xs text-gray-500">
                            {currentOccupancy}/{maxOccupancy} beds occupied
                          </span>
                          <span className={`text-[10px] px-2 py-0.5 rounded-full ${
                            isActive ? 'bg-green-50 text-green-600' : 'bg-yellow-50 text-yellow-600'
                          }`}>
                            {isActive ? 'Active' : 'Pending'}
                          </span>
                        </div>
                      </div>

                      <div className="mt-2">
                        <div className="w-full bg-gray-100 rounded-full h-1">
                          <div
                            className="bg-[#FF751F] h-1 rounded-full"
                            style={{ width: `${occupancyPercent}%` }}
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* ============================================ */}
      {/* EMPTY STATE */}
      {/* ============================================ */}
      {listings.length === 0 && (
        <div className="px-6 mt-8">
          <div className="bg-white rounded-2xl p-8 text-center border border-gray-100">
            <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-4">
              <Home className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-gray-800 font-medium text-base mb-1">No Listings Yet</h3>
            <p className="text-gray-400 text-sm mb-5">Start by adding your first property</p>
            <button
              onClick={onAddListing}
              className="px-5 py-2 bg-[#FF751F] text-white rounded-xl text-sm font-medium hover:bg-[#E96A19] transition-all"
            >
              + Add Listing
            </button>
          </div>
        </div>
      )}

      {/* ============================================ */}
      {/* FLOATING ACTION BUTTON - زر + العائم */}
      {/* ============================================ */}
      <button
        onClick={onAddListing}
        className={`fixed bottom-24 right-5 w-14 h-14 rounded-full bg-[#FF751F] shadow-2xl shadow-[#FF751F]/40 flex items-center justify-center hover:bg-[#E96A19] transition-all active:scale-95 z-20 ${
          showFloatingButton ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10 pointer-events-none'
        }`}
      >
        <Plus className="w-6 h-6 text-white" />
      </button>
    </div>
  );
}