import { useState } from 'react';
import { MapPin, Users, FileText, User, Heart, Star } from 'lucide-react';
import { Button } from '../../ui/button';
import { Input } from '../../ui/input';
import { Textarea } from '../../ui/textarea';
import { Label } from '../../ui/label';
import { FormHeader } from './component/FormHeader';
import { ProgressSteps } from './component/ProgressSteps';

const governorates = [
  'Cairo', 'Giza', 'Alexandria', 'Mansoura',
  'Assiut', 'Tanta', 'Zagazig', 'Ismailia'
];

interface AddPropertyLocationScreenProps {
  onNext: (data: LocationData) => void;
  onBack: () => void;
}

interface LocationData {
  governorate: string;
  district: string;
  address: string;
  buildingNumber: string;
  floor: number;
  genderPreference: 'male' | 'female';
  religionPreference: 'muslim' | 'christian' ;
  houseRules: string;
}

// Style constants للـ inputs
const inputClassName = "w-full h-12 px-4 rounded-xl border border-gray-200 bg-white focus:border-[#FF751F] focus:ring-4 focus:ring-[#FF751F]/10 outline-none transition-all";
const selectClassName = "w-full h-12 px-4 rounded-xl border border-gray-200 bg-white focus:border-[#FF751F] focus:ring-4 focus:ring-[#FF751F]/10 outline-none transition-all appearance-none bg-[url('data:image/svg+xml;charset=utf-8,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 fill=%27none%27 viewBox=%270 0 20 20%27%3E%3Cpath stroke=%27%236B7280%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27 stroke-width=%271.5%27 d=%27m6 8 4 4 4-4%27/%3E%3C/svg%3E')] bg-[right:1rem_center] bg-[length:1.25rem] bg-no-repeat";

export function AddPropertyLocationScreen({ onNext, onBack }: AddPropertyLocationScreenProps) {
  const [formData, setFormData] = useState<LocationData>({
    governorate: '',
    district: '',
    address: '',
    buildingNumber: '',
    floor: 1,
    genderPreference: 'male',
    religionPreference: 'any',
    houseRules: '',
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = () => {
    const newErrors: Record<string, string> = {};
    if (!formData.governorate) newErrors.governorate = 'Governorate is required';
    if (!formData.district) newErrors.district = 'District is required';
    if (!formData.address) newErrors.address = 'Address is required';
    
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }
    onNext(formData);
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Header */}
      <FormHeader title="Add Property" onBack={onBack} currentStep={1} totalSteps={4} />
      <ProgressSteps currentStep={1} />

      <div className="flex-1 overflow-y-auto px-5 py-4">
        
        {/* ✅ Mini Intro */}
        <div className="mb-5">
          <p className="text-sm text-gray-500 leading-relaxed">
            Tell students about your property location and preferences.
            <br />
            This helps us match the right tenants faster.
          </p>
        </div>

        <div className="space-y-5">
          
          {/* Section 1: Location */}
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-3 mb-5">
              <div className="w-10 h-10 rounded-xl bg-[#FFF1E8] flex items-center justify-center">
                <MapPin className="w-5 h-5 text-[#FF751F]" />
              </div>
              <h2 className="text-lg font-semibold text-[#022B60]">Where is your property?</h2>
            </div>
            
            <div className="space-y-4">
              {/* Governorate */}
              <div>
                <Label className="text-[#022B60] text-sm font-medium mb-1 block">Governorate *</Label>
                <select
                  value={formData.governorate}
                  onChange={(e) => setFormData({ ...formData, governorate: e.target.value })}
                  className={selectClassName}
                >
                  <option value="">Select governorate</option>
                  {governorates.map(g => <option key={g} value={g}>{g}</option>)}
                </select>
                {errors.governorate && <p className="text-red-500 text-xs mt-1">{errors.governorate}</p>}
              </div>
              
              {/* District */}
              <div>
                <Label className="text-[#022B60] text-sm font-medium mb-1 block">District / Area *</Label>
                <Input
                  placeholder="e.g., Maadi, Zamalek, Nasr City"
                  value={formData.district}
                  onChange={(e) => setFormData({ ...formData, district: e.target.value })}
                  className={inputClassName}
                />
                {errors.district && <p className="text-red-500 text-xs mt-1">{errors.district}</p>}
              </div>
              
              {/* Full Address */}
              <div>
                <Label className="text-[#022B60] text-sm font-medium mb-1 block">Full Address *</Label>
                <Input
                  placeholder="Example: 15 Ahmed Orabi St, near Metro Market"
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  className={inputClassName}
                />
                {errors.address && <p className="text-red-500 text-xs mt-1">{errors.address}</p>}
              </div>
              
              {/* Building Number & Floor */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <Label className="text-[#022B60] text-sm font-medium mb-1 block">Building Number</Label>
                  <Input
                    placeholder="123"
                    value={formData.buildingNumber}
                    onChange={(e) => setFormData({ ...formData, buildingNumber: e.target.value })}
                    className={inputClassName}
                  />
                </div>
                <div>
                  <Label className="text-[#022B60] text-sm font-medium mb-1 block">Floor Number</Label>
                  <Input
                    type="number"
                    placeholder="1"
                    value={formData.floor}
                    onChange={(e) => setFormData({ ...formData, floor: parseInt(e.target.value) || 0 })}
                    className={inputClassName}
                  />
                </div>
              </div>
            </div>
          </div>

          {/* Section 2: Property Rules */}
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-3 mb-5">
              <div className="w-10 h-10 rounded-xl bg-[#FFF1E8] flex items-center justify-center">
                <Users className="w-5 h-5 text-[#FF751F]" />
              </div>
              <h2 className="text-lg font-semibold text-[#022B60]">Who is this property for?</h2>
            </div>
            
            <div className="space-y-5">
              {/* Gender Preference */}
              <div>
                <Label className="text-[#022B60] text-sm font-medium mb-2 block">Gender Preference *</Label>
                <div className="flex gap-3">
                  <button
                    onClick={() => setFormData({ ...formData, genderPreference: 'male' })}
                    className={`flex-1 py-3 rounded-xl font-medium transition-all flex items-center justify-center gap-2 ${
                      formData.genderPreference === 'male'
                        ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
                        : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                    }`}
                  >
                    <User className="w-4 h-4" /> Male Only
                  </button>
                  <button
                    onClick={() => setFormData({ ...formData, genderPreference: 'female' })}
                    className={`flex-1 py-3 rounded-xl font-medium transition-all flex items-center justify-center gap-2 ${
                      formData.genderPreference === 'female'
                        ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
                        : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                    }`}
                  >
                    <User className="w-4 h-4" /> Female Only
                  </button>
                </div>
              </div>
{/* Religion Preference */}
<div>
  <Label className="text-[#022B60] text-sm font-medium mb-2 block">Religion Preference</Label>
  <div className="flex gap-2">
    <button
      onClick={() => setFormData({ ...formData, religionPreference: 'muslim' })}
      className={`flex-1 py-3 rounded-xl font-medium transition-all flex items-center justify-center gap-2 ${
        formData.religionPreference === 'muslim'
          ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
      }`}
    >
      ☪️ Muslim
    </button>
    <button
      onClick={() => setFormData({ ...formData, religionPreference: 'christian' })}
      className={`flex-1 py-3 rounded-xl font-medium transition-all flex items-center justify-center gap-2 ${
        formData.religionPreference === 'christian'
          ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
      }`}
    >
      ✝️ Christian
    </button>
  </div>
</div>
              {/* House Rules */}
              <div>
                <div className="flex items-center gap-2 mb-2">
                  <FileText className="w-4 h-4 text-[#FF751F]" />
                  <Label className="text-sm text-[#022B60]">House Rules (Optional)</Label>
                </div>
                <Textarea
                  placeholder="e.g., No smoking, quiet hours after 11 PM, no pets, visitors policy..."
                  rows={3}
                  value={formData.houseRules}
                  onChange={(e) => setFormData({ ...formData, houseRules: e.target.value })}
                  className="resize-none mt-1 rounded-xl border border-gray-200 focus:border-[#FF751F] focus:ring-4 focus:ring-[#FF751F]/10 outline-none transition-all p-3"
                />
                <p className="text-xs text-gray-400 mt-1">
                  Add any specific rules for tenants
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Button - with sticky shadow */}
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