import { useState } from 'react';
import { Camera, Plus, X, Trash2, Image, ChevronLeft, ChevronRight, Sparkles } from 'lucide-react';
import { Button } from '../../ui/button';
import { Label } from '../../ui/label';
import { FormHeader } from './component/FormHeader';
import { ProgressSteps } from './component/ProgressSteps';
import { StepHeader } from './component/StepHeader';
import { AutoSaveIndicator } from './component/AutoSaveIndicator';

interface AddPropertyPhotosScreenProps {
  onNext: (data: {
    livingRoomPhotos: string[];
    bathroomPhotos: string[];
    kitchenPhotos: string[];
    coverPhotoIndex: number;
  }) => void;
  onBack: () => void;
  initialLivingRoom?: string[];
  initialBathroom?: string[];
  initialKitchen?: string[];
}

type PhotoArea = 'livingRoom' | 'bathroom' | 'kitchen';

const areaConfig = {
  livingRoom: {
    title: 'Living Room',
    icon: '🛋️',
    maxPhotos: 3,
    tip: 'Show the main living area, seating, and natural light'
  },
  bathroom: {
    title: 'Bathroom',
    icon: '🚿',
    maxPhotos: 2,
    tip: 'Include sink, toilet, and shower area'
  },
  kitchen: {
    title: 'Kitchen',
    icon: '🍳',
    maxPhotos: 2,
    tip: 'Show appliances, counter space, and storage'
  }
};

function PhotoUploadCard({ area, photos, onAddPhoto, onRemovePhoto, onSetCover, coverIndex }: {
  area: PhotoArea;
  photos: string[];
  onAddPhoto: () => void;
  onRemovePhoto: (index: number) => void;
  onSetCover: (index: number) => void;
  coverIndex: number;
}) {
  const config = areaConfig[area];
  const [currentIndex, setCurrentIndex] = useState(0);

  const nextPhoto = () => {
    if (currentIndex < photos.length - 1) setCurrentIndex(currentIndex + 1);
  };

  const prevPhoto = () => {
    if (currentIndex > 0) setCurrentIndex(currentIndex - 1);
  };

  return (
    <div className="bg-white rounded-2xl p-5 shadow-sm border border-gray-100">
      <div className="flex items-center gap-3 mb-4">
        <div className="w-10 h-10 rounded-xl bg-[#FFF1E8] flex items-center justify-center">
          <span className="text-xl">{config.icon}</span>
        </div>
        <div>
          <h3 className="font-semibold text-[#022B60]">{config.title}</h3>
          <p className="text-xs text-gray-500">Upload up to {config.maxPhotos} photos</p>
        </div>
      </div>

      {/* Tip */}
      <div className="bg-blue-50 rounded-xl p-3 mb-4 flex items-start gap-2">
        <Sparkles className="w-4 h-4 text-blue-500 mt-0.5" />
        <p className="text-xs text-blue-600">{config.tip}</p>
      </div>

      {photos.length > 0 ? (
        <>
          {/* Main Photo Display */}
          <div className="relative mb-4">
            <img 
              src={photos[currentIndex]} 
              alt={`${config.title} ${currentIndex + 1}`}
              className="w-full h-48 object-cover rounded-xl"
            />
            {coverIndex === currentIndex && (
              <div className="absolute top-3 left-3 bg-[#FF751F] text-white text-xs px-2 py-1 rounded-full">
                Cover Photo
              </div>
            )}
            {photos.length > 1 && (
              <>
                <button
                  onClick={prevPhoto}
                  className="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-black/50 flex items-center justify-center text-white hover:bg-black/70"
                >
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <button
                  onClick={nextPhoto}
                  className="absolute right-2 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-black/50 flex items-center justify-center text-white hover:bg-black/70"
                >
                  <ChevronRight className="w-4 h-4" />
                </button>
              </>
            )}
            <button
              onClick={() => onRemovePhoto(currentIndex)}
              className="absolute top-3 right-3 w-8 h-8 rounded-full bg-black/50 flex items-center justify-center text-white hover:bg-black/70"
            >
              <Trash2 className="w-4 h-4" />
            </button>
          </div>

          {/* Thumbnails */}
          <div className="flex gap-2 overflow-x-auto pb-2">
            {photos.map((photo, idx) => (
              <div
                key={idx}
                className={`relative shrink-0 cursor-pointer transition-all ${
                  coverIndex === idx ? 'ring-2 ring-[#FF751F] rounded-lg' : ''
                }`}
                onClick={() => setCurrentIndex(idx)}
              >
                <img src={photo} className="w-16 h-16 object-cover rounded-lg" />
                {coverIndex !== idx && (
                  <button
                    onClick={(e) => { e.stopPropagation(); onSetCover(idx); }}
                    className="absolute bottom-1 right-1 bg-black/60 rounded-full p-0.5"
                  >
                    <Image className="w-3 h-3 text-white" />
                  </button>
                )}
              </div>
            ))}
            {photos.length < config.maxPhotos && (
              <button
                onClick={onAddPhoto}
                className="w-16 h-16 border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center hover:border-[#FF751F]"
              >
                <Plus className="w-5 h-5 text-gray-400" />
                <span className="text-xs text-gray-400">Add</span>
              </button>
            )}
          </div>
        </>
      ) : (
        // Empty State - Large Upload Card
        <button
          onClick={onAddPhoto}
          className="w-full border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-[#FF751F] transition-all"
        >
          <div className="w-16 h-16 rounded-full bg-[#FFF1E8] flex items-center justify-center mx-auto mb-3">
            <Camera className="w-8 h-8 text-[#FF751F]" />
          </div>
          <p className="text-[#022B60] font-medium">Upload Photos</p>
          <p className="text-xs text-gray-400 mt-1">Tap to add photos</p>
        </button>
      )}
    </div>
  );
}

export function AddPropertyPhotosScreen({ onNext, onBack, initialLivingRoom = [], initialBathroom = [], initialKitchen = [] }: AddPropertyPhotosScreenProps) {
  const [livingRoomPhotos, setLivingRoomPhotos] = useState<string[]>(initialLivingRoom);
  const [bathroomPhotos, setBathroomPhotos] = useState<string[]>(initialBathroom);
  const [kitchenPhotos, setKitchenPhotos] = useState<string[]>(initialKitchen);
  const [coverPhotoIndex, setCoverPhotoIndex] = useState(0);

  const handleAddPhoto = (area: PhotoArea) => {
    const newPhoto = `https://placehold.co/400x300/022B60/white?text=${area}&t=${Date.now()}`;
    if (area === 'livingRoom') {
      setLivingRoomPhotos(prev => [...prev, newPhoto]);
      if (livingRoomPhotos.length === 0 && coverPhotoIndex === 0) setCoverPhotoIndex(0);
    } else if (area === 'bathroom') {
      setBathroomPhotos(prev => [...prev, newPhoto]);
    } else {
      setKitchenPhotos(prev => [...prev, newPhoto]);
    }
  };

  const handleRemovePhoto = (area: PhotoArea, index: number) => {
    if (area === 'livingRoom') {
      setLivingRoomPhotos(prev => prev.filter((_, i) => i !== index));
      if (coverPhotoIndex === index) setCoverPhotoIndex(0);
      else if (coverPhotoIndex > index) setCoverPhotoIndex(prev => prev - 1);
    } else if (area === 'bathroom') {
      setBathroomPhotos(prev => prev.filter((_, i) => i !== index));
    } else {
      setKitchenPhotos(prev => prev.filter((_, i) => i !== index));
    }
  };

  const handleSetCover = (index: number) => {
    setCoverPhotoIndex(index);
  };

  const handleSubmit = () => {
    onNext({
      livingRoomPhotos,
      bathroomPhotos,
      kitchenPhotos,
      coverPhotoIndex,
    });
  };

  // Count total photos
  const totalPhotos = livingRoomPhotos.length + bathroomPhotos.length + kitchenPhotos.length;

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <FormHeader title="Add Property" onBack={onBack} currentStep={4} totalSteps={5} />
      <ProgressSteps currentStep={4} />

      <div className="flex-1 overflow-y-auto px-5 py-4 space-y-8">
        
        <StepHeader 
          title="Property Photos"
          description="Upload clear photos of shared spaces. Bright photos get more views."
          estimatedTime="3 minutes"
        />
        
        <AutoSaveIndicator />

        {/* Tips Banner */}
        <div className="bg-gradient-to-r from-[#FFF1E8] to-white rounded-2xl p-4 flex items-start gap-3 border border-gray-100">
          <div className="w-10 h-10 rounded-full bg-[#FF751F]/10 flex items-center justify-center">
            <Sparkles className="w-5 h-5 text-[#FF751F]" />
          </div>
          <div>
            <p className="text-sm font-medium text-[#022B60]">Pro Tip</p>
            <p className="text-xs text-gray-500 mt-0.5">
              Properties with clear, well-lit photos are rented 2x faster. 
              The first photo will be your cover image.
            </p>
          </div>
        </div>

        <PhotoUploadCard
          area="livingRoom"
          photos={livingRoomPhotos}
          onAddPhoto={() => handleAddPhoto('livingRoom')}
          onRemovePhoto={(idx) => handleRemovePhoto('livingRoom', idx)}
          onSetCover={handleSetCover}
          coverIndex={coverPhotoIndex}
        />

        <PhotoUploadCard
          area="bathroom"
          photos={bathroomPhotos}
          onAddPhoto={() => handleAddPhoto('bathroom')}
          onRemovePhoto={(idx) => handleRemovePhoto('bathroom', idx)}
          onSetCover={handleSetCover}
          coverIndex={coverPhotoIndex}
        />

        <PhotoUploadCard
          area="kitchen"
          photos={kitchenPhotos}
          onAddPhoto={() => handleAddPhoto('kitchen')}
          onRemovePhoto={(idx) => handleRemovePhoto('kitchen', idx)}
          onSetCover={handleSetCover}
          coverIndex={coverPhotoIndex}
        />
      </div>

      {/* Bottom Button - Sticky with total count */}
      <div className="sticky bottom-0 border-t border-gray-100 bg-white/95 backdrop-blur-md p-4 shadow-[0_-4px_20px_-5px_rgba(0,0,0,0.05)]">
        <div className="flex items-center justify-between mb-3">
          <span className="text-sm text-gray-600">{totalPhotos} photos uploaded</span>
          <span className="text-xs text-gray-400">{livingRoomPhotos.length + bathroomPhotos.length + kitchenPhotos.length}/7 total</span>
        </div>
        <Button
          onClick={handleSubmit}
          disabled={totalPhotos === 0}
          className="w-full bg-[#FF751F] hover:bg-[#E96A19] text-white h-12 rounded-xl font-semibold shadow-lg shadow-[#FF751F]/25 transition-all active:scale-95 disabled:bg-gray-300 disabled:cursor-not-allowed"
        >
          {totalPhotos === 0 ? 'Add at least one photo' : 'Continue'}
        </Button>
      </div>
    </div>
  );
}