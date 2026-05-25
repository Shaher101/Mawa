import { useState } from 'react';
import { MapPin, Users, Wifi, Bed, DollarSign, CheckCircle, Camera, Home, Flame, Droplets, Check, Clock, Sparkles, Star, FileText } from 'lucide-react';
import { Button } from '../../ui/button';
import { FormHeader } from './component/FormHeader';
import { ProgressSteps } from './component/ProgressSteps';

interface ReviewPropertyScreenProps {
  data: any;
  onSubmit: () => void;
  onBack: () => void;
}

export function ReviewPropertyScreen({ data, onSubmit, onBack }: ReviewPropertyScreenProps) {
  const [isConfirmed, setIsConfirmed] = useState(false);

  // حساب إجمالي الإيجار من الغرف
  const totalMonthlyRent = data.rooms?.reduce((total: number, room: any) => {
    return total + (room.pricePerBed * room.numberOfBeds);
  }, 0) || 0;

  const totalBeds = data.rooms?.reduce((total: number, room: any) => {
    return total + room.numberOfBeds;
  }, 0) || 0;

  const totalRooms = data.rooms?.length || 0;

  // حساب إجمالي التأمين
  const totalDeposit = data.rooms?.reduce((total: number, room: any) => {
    return total + (room.securityDepositPerBed * room.numberOfBeds);
  }, 0) || 0;

  // Amenities list
  const amenitiesList = [
    { id: 'wifi', name: 'WiFi', icon: Wifi, available: data.amenities?.includes('wifi') },
    { id: 'tv', name: 'TV', icon: Camera, available: data.amenities?.includes('tv') },
    { id: 'elevator', name: 'Elevator', icon: Home, available: data.amenities?.includes('elevator') },
    { id: 'microwave', name: 'Microwave', icon: Flame, available: data.amenities?.includes('microwave') },
    { id: 'freezer', name: 'Deep Freezer', icon: Droplets, available: data.amenities?.includes('freezer') },
    { id: 'washer', name: 'Washing Machine', icon: Sparkles, available: data.amenities?.includes('washer') },
  ];

  const coverPhoto = data.livingRoomPhotos?.[0] || data.photos?.[0] || null;

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <FormHeader title="Add Property" onBack={onBack} currentStep={5} totalSteps={5} />
      <ProgressSteps currentStep={5} />

      <div className="flex-1 overflow-y-auto px-5 py-4 space-y-6">
        
        {/* ============================================ */}
        {/* HERO PREVIEW - مع الصورة الحقيقية */}
        {/* ============================================ */}
        <div className="relative h-64 rounded-3xl overflow-hidden shadow-lg">
          {coverPhoto ? (
            <img
              src={coverPhoto}
              alt="Property cover"
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full bg-gradient-to-r from-[#022B60]/20 to-[#FF751F]/20 flex items-center justify-center">
              <Camera className="w-12 h-12 text-gray-400" />
            </div>
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
          
          <div className="absolute bottom-4 left-4">
            <div className="bg-black/40 backdrop-blur-md px-3 py-1.5 rounded-full">
              <span className="text-white text-xs font-medium flex items-center gap-1">
                <MapPin className="w-3.5 h-3.5" />
                {data.district}, {data.governorate}
              </span>
            </div>
          </div>

          <div className="absolute bottom-4 right-4">
            <div className="bg-black/40 backdrop-blur-md px-3 py-1.5 rounded-full">
              <div className="flex items-center gap-1.5">
                <Bed className="w-3.5 h-3.5 text-white" />
                <span className="text-white text-xs font-medium">
                  {totalBeds} {totalBeds === 1 ? 'Bed' : 'Beds'}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* ============================================ */}
        {/* LOCATION CARD - بدون Edit */}
        {/* ============================================ */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center gap-2 mb-3">
            <div className="w-8 h-8 rounded-full bg-[#FFF1E8] flex items-center justify-center">
              <MapPin className="w-4 h-4 text-[#FF751F]" />
            </div>
            <h3 className="font-semibold text-[#022B60]">Location</h3>
          </div>
          <div className="space-y-1">
            <p className="text-gray-700 text-sm">
              {data.district}, {data.governorate}
            </p>
            <p className="text-gray-500 text-xs">{data.address}</p>
            <p className="text-gray-500 text-xs">Building {data.buildingNumber}, Floor {data.floor}</p>
          </div>
        </div>

        {/* ============================================ */}
        {/* ROOMS & BEDS CARD - بدون Edit */}
        {/* ============================================ */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center gap-2 mb-3">
            <div className="w-8 h-8 rounded-full bg-[#FFF1E8] flex items-center justify-center">
              <Bed className="w-4 h-4 text-[#FF751F]" />
            </div>
            <h3 className="font-semibold text-[#022B60]">Rooms & Beds</h3>
          </div>
          <div className="flex flex-wrap gap-2 mb-3">
            <div className="px-3 py-1.5 bg-[#FFF1E8] text-[#FF751F] rounded-full text-sm font-medium">
              {totalRooms} {totalRooms === 1 ? 'Room' : 'Rooms'}
            </div>
            <div className="px-3 py-1.5 bg-[#022B60]/10 text-[#022B60] rounded-full text-sm font-medium flex items-center gap-1">
              <Bed className="w-3.5 h-3.5" />
              {totalBeds} {totalBeds === 1 ? 'Bed' : 'Beds'}
            </div>
            <div className="px-3 py-1.5 bg-green-50 text-green-600 rounded-full text-sm font-medium flex items-center gap-1">
              <DollarSign className="w-3.5 h-3.5" />
              {totalMonthlyRent.toLocaleString()} EGP/month
            </div>
          </div>
          <p className="text-xs text-gray-500">
            Starting from {data.rooms?.[0]?.pricePerBed?.toLocaleString()} EGP / bed
          </p>
        </div>

        {/* ============================================ */}
        {/* PREFERENCES CARD - بدون Edit */}
        {/* ============================================ */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center gap-2 mb-3">
            <div className="w-8 h-8 rounded-full bg-[#FFF1E8] flex items-center justify-center">
              <Users className="w-4 h-4 text-[#FF751F]" />
            </div>
            <h3 className="font-semibold text-[#022B60]">Preferences</h3>
          </div>
          <div className="flex flex-wrap gap-2">
            <div className="px-3 py-1.5 bg-[#FFF1E8] text-[#FF751F] rounded-full text-sm font-medium flex items-center gap-1">
              <Users className="w-3.5 h-3.5" />
              {data.genderPreference === 'male' ? 'Male Only' : 'Female Only'}
            </div>
            <div className="px-3 py-1.5 bg-[#022B60]/10 text-[#022B60] rounded-full text-sm font-medium flex items-center gap-1">
              <Star className="w-3.5 h-3.5" />
              {data.religionPreference === 'muslim' ? 'Muslim' : data.religionPreference === 'christian' ? 'Christian' : 'Any Religion'}
            </div>
            {data.houseRules && (
              <div className="px-3 py-1.5 bg-gray-100 text-gray-600 rounded-full text-sm font-medium flex items-center gap-1">
                <FileText className="w-3.5 h-3.5" />
                {data.houseRules.length > 30 ? data.houseRules.slice(0, 30) + '...' : data.houseRules}
              </div>
            )}
          </div>
        </div>

        {/* ============================================ */}
        {/* UTILITIES CARD - بدون Edit */}
        {/* ============================================ */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center gap-2 mb-3">
            <div className="w-8 h-8 rounded-full bg-[#FFF1E8] flex items-center justify-center">
              <Droplets className="w-4 h-4 text-[#FF751F]" />
            </div>
            <h3 className="font-semibold text-[#022B60]">Utilities</h3>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-gray-50 rounded-xl p-3 flex items-center gap-3">
              <Droplets className="w-5 h-5 text-[#FF751F]" />
              <div>
                <p className="text-sm font-medium text-gray-800">Electricity & Water</p>
                <p className="text-xs text-gray-500">{data.utilitiesBill === 'student' ? 'Student pays' : 'Owner pays'}</p>
              </div>
            </div>
            <div className="bg-gray-50 rounded-xl p-3 flex items-center gap-3">
              <Flame className="w-5 h-5 text-[#FF751F]" />
              <div>
                <p className="text-sm font-medium text-gray-800">Gas Type</p>
                <p className="text-xs text-gray-500">{data.gasType === 'natural' ? 'Natural Gas' : 'Cylinder'}</p>
              </div>
            </div>
          </div>
        </div>

        {/* ============================================ */}
        {/* AMENITIES CARD - بدون Edit */}
        {/* ============================================ */}
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
          <div className="flex items-center gap-2 mb-3">
            <div className="w-8 h-8 rounded-full bg-[#FFF1E8] flex items-center justify-center">
              <Sparkles className="w-4 h-4 text-[#FF751F]" />
            </div>
            <h3 className="font-semibold text-[#022B60]">Amenities</h3>
          </div>
          <div className="grid grid-cols-2 gap-2">
            {amenitiesList.filter(a => a.available).map((amenity) => (
              <div key={amenity.id} className="flex items-center gap-2 text-sm text-gray-600">
                <amenity.icon className="w-4 h-4 text-[#FF751F]" />
                <span>{amenity.name}</span>
              </div>
            ))}
            {amenitiesList.filter(a => a.available).length === 0 && (
              <p className="text-sm text-gray-500 col-span-2">No amenities selected</p>
            )}
          </div>
        </div>

        {/* ============================================ */}
        {/* SUMMARY CARD - Navy Background */}
        {/* ============================================ */}
        <div className="bg-[#022B60] rounded-3xl p-5 text-white">
          <h3 className="font-semibold text-white/80 text-sm mb-3">Listing Summary</h3>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-white/60 text-xs">Total Rooms</p>
              <p className="text-2xl font-bold">{totalRooms}</p>
            </div>
            <div>
              <p className="text-white/60 text-xs">Total Beds</p>
              <p className="text-2xl font-bold">{totalBeds}</p>
            </div>
            <div>
              <p className="text-white/60 text-xs">Monthly Rent</p>
              <p className="text-xl font-bold">{totalMonthlyRent.toLocaleString()} EGP</p>
            </div>
            <div>
              <p className="text-white/60 text-xs">Security Deposit</p>
              <p className="text-xl font-bold">{totalDeposit.toLocaleString()} EGP</p>
            </div>
          </div>
          <div className="mt-3 pt-3 border-t border-white/20">
            <p className="text-white/60 text-xs">Bills: {data.utilitiesBill === 'student' ? 'Student pays' : 'Included in rent'}</p>
          </div>
        </div>

        {/* ============================================ */}
        {/* ESTIMATED APPROVAL CARD */}
        {/* ============================================ */}
        <div className="bg-green-50 border border-green-100 rounded-2xl p-4 flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center">
            <Clock className="w-5 h-5 text-green-600" />
          </div>
          <div>
            <p className="text-sm font-medium text-green-800">Estimated approval within 24 hours</p>
            <p className="text-xs text-green-600">Verified listings are approved faster</p>
          </div>
        </div>

        {/* ============================================ */}
        {/* CONFIRMATION CARD - Custom Checkbox */}
        {/* ============================================ */}
        <button
          onClick={() => setIsConfirmed(!isConfirmed)}
          className={`w-full rounded-2xl p-4 border-2 transition-all flex items-start gap-3 text-left ${
            isConfirmed
              ? 'border-[#FF751F] bg-[#FFF1E8]'
              : 'border-gray-200 bg-white'
          }`}
        >
          <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center mt-0.5 shrink-0 ${
            isConfirmed
              ? 'border-[#FF751F] bg-[#FF751F]'
              : 'border-gray-300'
          }`}>
            {isConfirmed && <Check className="w-3 h-3 text-white" />}
          </div>
          <div>
            <p className="text-sm font-medium text-gray-800">I confirm that all information is correct and complete</p>
            <p className="text-xs text-gray-500 mt-0.5">Your listing will be reviewed by our team</p>
          </div>
        </button>
      </div>

      {/* ============================================ */}
      {/* BOTTOM BUTTON - Sticky */}
      {/* ============================================ */}
      <div className="sticky bottom-0 border-t border-gray-200 p-4 bg-white/95 backdrop-blur-md shadow-[0_-4px_20px_-5px_rgba(0,0,0,0.05)]">
        <Button
          onClick={onSubmit}
          disabled={!isConfirmed}
          className="w-full bg-[#FF751F] hover:bg-[#E96A19] text-white h-14 rounded-xl font-semibold text-base shadow-lg shadow-[#FF751F]/25 transition-all active:scale-95 disabled:bg-gray-300 disabled:cursor-not-allowed"
        >
          {!isConfirmed ? 'Confirm to Submit' : 'Submit Property'}
        </Button>
        <p className="text-center text-xs text-gray-400 mt-3">
          By submitting, you agree to our Terms of Service
        </p>
      </div>
    </div>
  );
}