import { useState } from 'react';
import { Bed, Plus, ChevronRight, Trash2, Snowflake, Wind } from 'lucide-react';
import { Button } from '../../ui/button';
import { Input } from '../../ui/input';
import { Label } from '../../ui/label';
import { FormHeader } from './component/FormHeader';
import { ProgressSteps } from './component/ProgressSteps';
import { StepHeader } from './component/StepHeader';
import { AutoSaveIndicator } from './component/AutoSaveIndicator';
import { FeatureChip } from './component/FeatureChip';

interface RoomData {
  id: string;
  numberOfBeds: number;
  coolingType: 'ac' | 'fan';
  features: {
    hasWindow: boolean;
    hasBalcony: boolean;
    hasDesk: boolean;
    hasWardrobe: boolean;
  };
  pricePerBed: number;
  securityDepositPerBed: number;
  photos: string[];
}

interface AddPropertyRoomsScreenProps {
  onNext: (data: { rooms: RoomData[] }) => void;
  onBack: () => void;
  initialRooms?: RoomData[];
}

// Room Card Component (Accordion)
function RoomCard({ room, index, onUpdate, onDelete, isExpanded, onToggleExpand }: {
  room: RoomData;
  index: number;
  onUpdate: (updates: Partial<RoomData>) => void;
  onDelete: () => void;
  isExpanded: boolean;
  onToggleExpand: () => void;
}) {
  const roomTotalPrice = room.pricePerBed * room.numberOfBeds;

  const featuresList = [
    { type: 'window', value: room.features.hasWindow, field: 'hasWindow' },
    { type: 'balcony', value: room.features.hasBalcony, field: 'hasBalcony' },
    { type: 'desk', value: room.features.hasDesk, field: 'hasDesk' },
    { type: 'wardrobe', value: room.features.hasWardrobe, field: 'hasWardrobe' },
  ];

  return (
    <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
      {/* Card Header */}
      <div 
        className="p-5 flex items-center justify-between cursor-pointer hover:bg-gray-50 transition-colors"
        onClick={onToggleExpand}
      >
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#FFF1E8] flex items-center justify-center">
            <Bed className="w-5 h-5 text-[#FF751F]" />
          </div>
          <div>
            <h3 className="font-semibold text-[#022B60]">Room {index + 1}</h3>
            <div className="flex items-center gap-3 text-xs text-gray-500 mt-1">
              <span>🛏️ {room.numberOfBeds} {room.numberOfBeds === 1 ? 'bed' : 'beds'}</span>
              <span>❄️ {room.coolingType === 'ac' ? 'AC' : 'Fan'}</span>
              <span className="text-[#FF751F] font-medium">{roomTotalPrice.toLocaleString()} EGP</span>
            </div>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <button 
            onClick={(e) => { e.stopPropagation(); onDelete(); }}
            className="p-2 text-gray-400 hover:text-red-500 transition-colors"
          >
            <Trash2 className="w-4 h-4" />
          </button>
          <ChevronRight className={`w-5 h-5 text-gray-400 transition-transform ${isExpanded ? 'rotate-90' : ''}`} />
        </div>
      </div>

      {/* Expanded Content */}
      {isExpanded && (
        <div className="border-t border-gray-100 p-5 space-y-5 bg-gray-50/50">
          
          {/* Number of Beds */}
          <div>
            <Label className="text-[#022B60] text-sm flex items-center gap-1">🛏️ Number of Beds</Label>
            <Input
              type="number"
              value={room.numberOfBeds}
              onChange={(e) => onUpdate({ numberOfBeds: parseInt(e.target.value) || 1 })}
              className="mt-1 bg-white h-11"
            />
          </div>

          {/* Cooling Type */}
          <div>
            <Label className="text-[#022B60] text-sm mb-2 block">❄️ Cooling System</Label>
            <div className="flex gap-3">
              <button
                onClick={() => onUpdate({ coolingType: 'ac' })}
                className={`flex-1 py-3 rounded-xl font-medium transition-all flex items-center justify-center gap-2 ${
                  room.coolingType === 'ac'
                    ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
                    : 'bg-white text-gray-600 hover:bg-gray-100 border border-gray-200'
                }`}
              >
                <Snowflake className="w-4 h-4" /> AC
              </button>
              <button
                onClick={() => onUpdate({ coolingType: 'fan' })}
                className={`flex-1 py-3 rounded-xl font-medium transition-all flex items-center justify-center gap-2 ${
                  room.coolingType === 'fan'
                    ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
                    : 'bg-white text-gray-600 hover:bg-gray-100 border border-gray-200'
                }`}
              >
                <Wind className="w-4 h-4" /> Fan
              </button>
            </div>
          </div>

          {/* Features - Chips */}
          <div>
            <Label className="text-[#022B60] text-sm mb-2 block">Room Features</Label>
            <div className="flex flex-wrap gap-2">
              {featuresList.map((feature) => (
                <FeatureChip
                  key={feature.type}
                  type={feature.type as 'window' | 'balcony' | 'desk' | 'wardrobe'}
                  active={feature.value}
                  onToggle={() => onUpdate({ 
                    features: { ...room.features, [feature.field]: !feature.value } 
                  })}
                />
              ))}
            </div>
          </div>

          {/* Pricing */}
          <div className="bg-white rounded-xl p-4 space-y-3 border border-gray-100">
            <Label className="text-[#022B60] text-sm font-medium">💰 Pricing</Label>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <Label className="text-gray-500 text-xs">Price per Bed (EGP/month)</Label>
                <Input
                  type="number"
                  value={room.pricePerBed}
                  onChange={(e) => onUpdate({ pricePerBed: parseInt(e.target.value) || 0 })}
                  className="mt-1"
                />
              </div>
              <div>
                <Label className="text-gray-500 text-xs">Security Deposit (EGP)</Label>
                <Input
                  type="number"
                  value={room.securityDepositPerBed}
                  onChange={(e) => onUpdate({ securityDepositPerBed: parseInt(e.target.value) || 0 })}
                  className="mt-1"
                />
              </div>
            </div>
            <div className="pt-2 border-t border-gray-100 flex justify-between">
              <span className="text-sm text-gray-600">Room Total:</span>
              <span className="font-semibold text-[#FF751F]">{roomTotalPrice.toLocaleString()} EGP/month</span>
            </div>
          </div>

          {/* Photos */}
          <div>
            <Label className="text-[#022B60] text-sm mb-2 block">📸 Room Photos</Label>
            <div className="grid grid-cols-3 gap-2">
              {room.photos.slice(0, 3).map((photo, idx) => (
                <div key={idx} className="relative">
                  <img src={photo} className="w-full h-20 object-cover rounded-lg" />
                </div>
              ))}
              <label className="w-full h-20 border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center cursor-pointer hover:border-[#FF751F]">
                <Plus className="w-5 h-5 text-gray-400" />
                <span className="text-xs text-gray-400 mt-1">Add</span>
                <input type="file" accept="image/*" className="hidden" />
              </label>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export function AddPropertyRoomsScreen({ onNext, onBack, initialRooms = [] }: AddPropertyRoomsScreenProps) {
  const [rooms, setRooms] = useState<RoomData[]>(() => {
    if (initialRooms.length > 0) return initialRooms;
    return [{
      id: Date.now().toString(),
      numberOfBeds: 1,
      coolingType: 'fan',
      features: {
        hasWindow: true,
        hasBalcony: false,
        hasDesk: false,
        hasWardrobe: true,
      },
      pricePerBed: 0,
      securityDepositPerBed: 0,
      photos: [],
    }];
  });

  const [expandedRoomId, setExpandedRoomId] = useState<string | null>(rooms[0]?.id || null);

  const updateRoom = (roomId: string, updates: Partial<RoomData>) => {
    setRooms(prev => prev.map(room =>
      room.id === roomId ? { ...room, ...updates } : room
    ));
  };

  const addRoom = () => {
    const newRoom: RoomData = {
      id: Date.now().toString(),
      numberOfBeds: 1,
      coolingType: 'fan',
      features: {
        hasWindow: true,
        hasBalcony: false,
        hasDesk: false,
        hasWardrobe: true,
      },
      pricePerBed: 0,
      securityDepositPerBed: 0,
      photos: [],
    };
    setRooms(prev => [...prev, newRoom]);
    setExpandedRoomId(newRoom.id);
  };

  const deleteRoom = (roomId: string) => {
    if (rooms.length === 1) return;
    setRooms(prev => prev.filter(room => room.id !== roomId));
    if (expandedRoomId === roomId) {
      setExpandedRoomId(rooms[0]?.id || null);
    }
  };

  const toggleExpand = (roomId: string) => {
    setExpandedRoomId(prev => prev === roomId ? null : roomId);
  };

  const handleSubmit = () => {
    onNext({ rooms });
  };

  const totalBeds = rooms.reduce((acc, room) => acc + room.numberOfBeds, 0);
  const totalMonthlyRent = rooms.reduce((acc, room) => acc + (room.pricePerBed * room.numberOfBeds), 0);

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <FormHeader title="Add Property" onBack={onBack} currentStep={2} totalSteps={4} />
      <ProgressSteps currentStep={2} />

      <div className="flex-1 overflow-y-auto px-5 py-4">
        
        {/* Step Header */}
        <StepHeader 
          title="Rooms & Pricing"
          description="Add room details, beds, pricing, and photos."
          estimatedTime="2 minutes"
        />
        
        {/* Auto Save Indicator */}
        <AutoSaveIndicator />

        {/* Room Summary Cards */}
        <div className="grid grid-cols-3 gap-3 mb-6">
          <div className="bg-white rounded-xl p-3 text-center shadow-sm border border-gray-100">
            <p className="text-2xl font-bold text-[#022B60]">{rooms.length}</p>
            <p className="text-xs text-gray-500">Rooms</p>
          </div>
          <div className="bg-white rounded-xl p-3 text-center shadow-sm border border-gray-100">
            <p className="text-2xl font-bold text-[#022B60]">{totalBeds}</p>
            <p className="text-xs text-gray-500">Total Beds</p>
          </div>
          <div className="bg-white rounded-xl p-3 text-center shadow-sm border border-gray-100">
            <p className="text-2xl font-bold text-[#FF751F]">{totalMonthlyRent.toLocaleString()} EGP</p>
            <p className="text-xs text-gray-500">Monthly Rent</p>
          </div>
        </div>

        {/* Rooms List */}
        <div className="space-y-4">
          {rooms.map((room, index) => (
            <RoomCard
              key={room.id}
              room={room}
              index={index}
              onUpdate={(updates) => updateRoom(room.id, updates)}
              onDelete={() => deleteRoom(room.id)}
              isExpanded={expandedRoomId === room.id}
              onToggleExpand={() => toggleExpand(room.id)}
            />
          ))}
        </div>

        {/* Add Room Button */}
        <button
          onClick={addRoom}
          className="w-full mt-4 border-2 border-dashed border-gray-300 rounded-2xl p-4 text-[#FF751F] hover:border-[#FF751F] transition-all flex items-center justify-center gap-2"
        >
          <Plus className="w-5 h-5" />
          <span className="font-medium">Add Another Room</span>
        </button>
      </div>

      {/* Bottom Button - Sticky */}
      <div className="sticky bottom-0 border-t border-gray-100 bg-white/95 backdrop-blur-md p-4 shadow-[0_-4px_20px_-5px_rgba(0,0,0,0.05)]">
        <Button
          onClick={handleSubmit}
          className="w-full bg-[#FF751F] hover:bg-[#E96A19] text-white h-12 rounded-xl font-semibold shadow-lg shadow-[#FF751F]/25 transition-all active:scale-95"
        >
          Continue
        </Button>
      </div>
    </div>
  );
}