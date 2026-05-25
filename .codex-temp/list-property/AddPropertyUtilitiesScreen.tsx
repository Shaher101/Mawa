import { useState } from 'react';
import { Wifi, Tv, Building2, Microwave, Archive, Shirt, Droplets, Flame, Check, Sparkles } from 'lucide-react';
import { Button } from '../../ui/button';
import { Label } from '../../ui/label';
import { FormHeader } from './component/FormHeader';
import { ProgressSteps } from './component/ProgressSteps';
import { StepHeader } from './component/StepHeader';
import { AutoSaveIndicator } from './component/AutoSaveIndicator';

// ✅ Amenities List - بدون تصنيفات
const AMENITIES_LIST = [
  { id: 'wifi', name: 'WiFi', icon: Wifi },
  { id: 'tv', name: 'TV', icon: Tv },
  { id: 'elevator', name: 'Elevator', icon: Building2 },
  { id: 'microwave', name: 'Microwave', icon: Microwave },
  { id: 'freezer', name: 'Deep Freezer', icon: Archive },
  { id: 'washer', name: 'Washing Machine', icon: Shirt },
];

interface AddPropertyUtilitiesScreenProps {
  onNext: (data: {
    utilitiesBill: 'student' | 'owner';
    gasType: 'natural' | 'cylinder';
    waterHeater: 'electric' | 'gas';
    amenities: string[];
  }) => void;
  onBack: () => void;
}

export function AddPropertyUtilitiesScreen({ onNext, onBack }: AddPropertyUtilitiesScreenProps) {
  const [utilitiesBill, setUtilitiesBill] = useState<'student' | 'owner'>('student');
  const [gasType, setGasType] = useState<'natural' | 'cylinder'>('natural');
  const [waterHeater, setWaterHeater] = useState<'electric' | 'gas'>('electric');
  const [amenities, setAmenities] = useState<string[]>([]);

  const toggleAmenity = (amenityId: string) => {
    setAmenities(prev =>
      prev.includes(amenityId)
        ? prev.filter(a => a !== amenityId)
        : [...prev, amenityId]
    );
  };

  const handleSubmit = () => {
    onNext({
      utilitiesBill,
      gasType,
      waterHeater,
      amenities,
    });
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <FormHeader title="Add Property" onBack={onBack} currentStep={3} totalSteps={5} />
      <ProgressSteps currentStep={3} />

      <div className="flex-1 overflow-y-auto px-5 py-4 space-y-8">
        
        {/* Step Header */}
        <StepHeader 
          title="Utilities & Amenities"
          description="Tell students about bills and what your property offers."
          estimatedTime="2 minutes"
        />
        
        <AutoSaveIndicator />

        {/* ============================================ */}
        {/* SECTION 1: UTILITIES CARDS */}
        {/* ============================================ */}
        <div>
          <h3 className="text-lg font-semibold text-[#022B60] mb-4">Utilities & Bills</h3>
          
          {/* Electricity & Water - Cards */}
          <div className="mb-6">
            <Label className="text-[#022B60] text-sm mb-3 block">Electricity & Water Bill</Label>
            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => setUtilitiesBill('student')}
                className={`p-4 rounded-xl border-2 transition-all text-left ${
                  utilitiesBill === 'student'
                    ? 'border-[#FF751F] bg-[#FFF1E8] shadow-md'
                    : 'border-gray-200 bg-white hover:border-[#FF751F]/50'
                }`}
              >
                <div className="flex items-center gap-2 mb-2">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                    utilitiesBill === 'student' ? 'bg-[#FF751F] text-white' : 'bg-gray-100 text-gray-500'
                  }`}>
                    <Droplets className="w-4 h-4" />
                  </div>
                  {utilitiesBill === 'student' && <Check className="w-4 h-4 text-[#FF751F] ml-auto" />}
                </div>
                <p className="font-semibold text-gray-800">Student pays</p>
                <p className="text-xs text-gray-500 mt-1">Bills paid monthly by tenants</p>
              </button>
              <button
                onClick={() => setUtilitiesBill('owner')}
                className={`p-4 rounded-xl border-2 transition-all text-left ${
                  utilitiesBill === 'owner'
                    ? 'border-[#FF751F] bg-[#FFF1E8] shadow-md'
                    : 'border-gray-200 bg-white hover:border-[#FF751F]/50'
                }`}
              >
                <div className="flex items-center gap-2 mb-2">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                    utilitiesBill === 'owner' ? 'bg-[#FF751F] text-white' : 'bg-gray-100 text-gray-500'
                  }`}>
                    <Sparkles className="w-4 h-4" />
                  </div>
                  {utilitiesBill === 'owner' && <Check className="w-4 h-4 text-[#FF751F] ml-auto" />}
                </div>
                <p className="font-semibold text-gray-800">Included in rent</p>
                <p className="text-xs text-gray-500 mt-1">Owner covers all utilities</p>
              </button>
            </div>
          </div>

          {/* Gas Type & Water Heater - Chips */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label className="text-[#022B60] text-sm mb-2 block flex items-center gap-2">
                <Flame className="w-4 h-4" /> Gas Type
              </Label>
              <div className="flex gap-2">
                <button
                  onClick={() => setGasType('natural')}
                  className={`flex-1 py-2 px-3 rounded-full text-sm font-medium transition-all flex items-center justify-center gap-1 ${
                    gasType === 'natural'
                      ? 'bg-[#FF751F] text-white shadow-sm'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  Natural Gas
                </button>
                <button
                  onClick={() => setGasType('cylinder')}
                  className={`flex-1 py-2 px-3 rounded-full text-sm font-medium transition-all flex items-center justify-center gap-1 ${
                    gasType === 'cylinder'
                      ? 'bg-[#FF751F] text-white shadow-sm'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  Cylinder
                </button>
              </div>
            </div>
            <div>
              <Label className="text-[#022B60] text-sm mb-2 block flex items-center gap-2">
                <Droplets className="w-4 h-4" /> Water Heater
              </Label>
              <div className="flex gap-2">
                <button
                  onClick={() => setWaterHeater('electric')}
                  className={`flex-1 py-2 px-3 rounded-full text-sm font-medium transition-all flex items-center justify-center gap-1 ${
                    waterHeater === 'electric'
                      ? 'bg-[#FF751F] text-white shadow-sm'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  Electric
                </button>
                <button
                  onClick={() => setWaterHeater('gas')}
                  className={`flex-1 py-2 px-3 rounded-full text-sm font-medium transition-all flex items-center justify-center gap-1 ${
                    waterHeater === 'gas'
                      ? 'bg-[#FF751F] text-white shadow-sm'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  Gas
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* ============================================ */}
        {/* SECTION 2: AMENITIES GRID (بدون تصنيفات) */}
        {/* ============================================ */}
        <div>
          <h3 className="text-lg font-semibold text-[#022B60] mb-4">Amenities</h3>
          <div className="grid grid-cols-2 gap-3">
            {AMENITIES_LIST.map((amenity) => {
              const Icon = amenity.icon;
              const isSelected = amenities.includes(amenity.id);
              return (
                <button
                  key={amenity.id}
                  onClick={() => toggleAmenity(amenity.id)}
                  className={`relative p-4 rounded-xl border-2 transition-all flex flex-col items-center gap-2 ${
                    isSelected
                      ? 'border-[#FF751F] bg-[#FFF1E8] shadow-md scale-[1.02]'
                      : 'border-gray-200 bg-white hover:border-[#FF751F]/50'
                  }`}
                >
                  {isSelected && (
                    <div className="absolute top-2 right-2">
                      <Check className="w-4 h-4 text-[#FF751F]" />
                    </div>
                  )}
                  <Icon className={`w-6 h-6 ${isSelected ? 'text-[#FF751F]' : 'text-gray-500'}`} />
                  <span className={`text-sm ${isSelected ? 'text-[#022B60] font-medium' : 'text-gray-600'}`}>
                    {amenity.name}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
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