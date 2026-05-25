import { useState, useRef } from 'react';
import { X, Shield, Camera, CheckCircle, Upload, Lock, FileText, Image } from 'lucide-react';
import { Button } from '../../ui/button';
import { Input } from '../../ui/input';
import { Label } from '../../ui/label';

interface VerifyIdentityModalProps {
  isOpen: boolean;
  onClose: () => void;
  onVerify: (data: { nationalId: string; frontImage: File; backImage: File }) => void;
}

function UploadCard({ title, file, onFileSelect, onRemove }: {
  title: string;
  file: { file: File; preview: string } | null;
  onFileSelect: (file: File) => void;
  onRemove: () => void;
}) {
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => {
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    const droppedFile = e.dataTransfer.files[0];
    if (droppedFile && droppedFile.type.startsWith('image/')) {
      onFileSelect(droppedFile);
    }
  };

  return (
    <div
      className={`relative rounded-xl border-2 border-dashed transition-all ${
        file 
          ? 'border-[#FF751F] bg-[#FF751F]/5' 
          : isDragging 
            ? 'border-[#FF751F] bg-[#FF751F]/10' 
            : 'border-[#DBE4F0] hover:border-[#FF751F]/50 bg-gray-50'
      }`}
      onDragOver={handleDragOver}
      onDragLeave={handleDragLeave}
      onDrop={handleDrop}
    >
      <input
        type="file"
        accept="image/*"
        className="hidden"
        ref={fileInputRef}
        onChange={(e) => {
          const selectedFile = e.target.files?.[0];
          if (selectedFile) onFileSelect(selectedFile);
        }}
      />
      
      {file ? (
        <div className="p-2">
          <div className="relative">
            <img src={file.preview} alt={title} className="w-full h-32 object-cover rounded-lg" />
            <button
              onClick={onRemove}
              className="absolute top-1 right-1 bg-black/50 rounded-full p-1 hover:bg-black/70"
            >
              <X className="w-3 h-3 text-white" />
            </button>
            <div className="absolute top-1 left-1 bg-green-500 rounded-full p-1">
              <CheckCircle className="w-3 h-3 text-white" />
            </div>
          </div>
        </div>
      ) : (
        <div 
          className="p-6 text-center cursor-pointer"
          onClick={() => fileInputRef.current?.click()}
        >
          <div className="w-12 h-12 rounded-full bg-[#FFF1E8] flex items-center justify-center mx-auto mb-3">
            <Camera className="w-6 h-6 text-[#FF751F]" />
          </div>
          <p className="font-medium text-[#022B60] text-sm">{title}</p>
          <p className="text-xs text-gray-400 mt-1">Tap to upload</p>
        </div>
      )}
    </div>
  );
}

export function VerifyIdentityModal({ isOpen, onClose, onVerify }: VerifyIdentityModalProps) {
  const [nationalId, setNationalId] = useState('');
  const [frontImage, setFrontImage] = useState<{ file: File; preview: string } | null>(null);
  const [backImage, setBackImage] = useState<{ file: File; preview: string } | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  if (!isOpen) return null;

  const handleSubmit = async () => {
    const newErrors: Record<string, string> = {};
    if (!nationalId) newErrors.nationalId = 'National ID is required';
    if (!frontImage) newErrors.frontImage = 'Front side is required';
    if (!backImage) newErrors.backImage = 'Back side is required';
    
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setIsLoading(true);
    try {
      await onVerify({ 
        nationalId, 
        frontImage: frontImage.file, 
        backImage: backImage.file 
      });
    } finally {
      setIsLoading(false);
    }
  };

  return (
  //  <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
    // جديد (يظهر في النص):
<div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Backdrop with blur */}
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      
      {/* Modal Content - أوسع */}
      <div className="relative bg-white rounded-2xl w-full max-w-md max-h-[90vh] overflow-y-auto animate-in fade-in zoom-in-95 duration-200 shadow-2xl">
        
        {/* Close Button - فوق يمين */}
        <button 
          onClick={onClose} 
          className="absolute top-4 right-4 z-10 w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 hover:text-gray-600"
        >
          <X className="w-4 h-4" />
        </button>

        {/* Hero Section - Centered */}
        <div className="pt-8 pb-4 px-6 text-center">
          {/* Step indicator */}
          <p className="text-xs font-medium text-[#FF751F] mb-3">Verification Required</p>
          
          {/* Hero Icon */}
          <div className="w-20 h-20 rounded-full bg-[#FFF1E8] flex items-center justify-center mx-auto mb-4">
            <Shield className="w-10 h-10 text-[#FF751F]" />
          </div>
          
          <h2 className="text-xl font-bold text-[#022B60]">Verify Your Identity</h2>
          <p className="text-sm text-gray-500 mt-1">Required only once</p>
        </div>

        <div className="px-6 pb-6 space-y-5">
          
          {/* ✅ What You'll Need Section */}
          {/*
<div className="bg-[#F8FAFC] rounded-2xl p-4 border border-gray-100">
            <h3 className="text-sm font-semibold text-[#022B60] mb-3">What you'll need</h3>
            <div className="space-y-2">
              <div className="flex items-center gap-3">
                <FileText className="w-4 h-4 text-[#FF751F]" />
                <span className="text-sm text-gray-600">National ID number</span>
              </div>
              <div className="flex items-center gap-3">
                <Image className="w-4 h-4 text-[#FF751F]" />
                <span className="text-sm text-gray-600">Front side photo of ID</span>
              </div>
              <div className="flex items-center gap-3">
                <Image className="w-4 h-4 text-[#FF751F]" />
                <span className="text-sm text-gray-600">Back side photo of ID</span>
              </div>
            </div>
          </div>

            
          */}
          
          {/* National ID Input */}
          <div>
            <Label className="text-[#022B60] text-sm font-medium mb-1 block">
              National ID Number
            </Label>
            <Input
              placeholder="Enter your National ID number"
              value={nationalId}
              onChange={(e) => {
                setNationalId(e.target.value);
                setErrors(prev => ({ ...prev, nationalId: undefined }));
              }}
              className="h-11"
            />
            {errors.nationalId && <p className="text-red-500 text-xs mt-1">{errors.nationalId}</p>}
          </div>

          {/* Upload Cards */}
          <div>
            <Label className="text-[#022B60] text-sm font-medium mb-2 block">
              Upload ID Card
            </Label>
            <div className="grid grid-cols-2 gap-3">
              <UploadCard
                title="Front Side"
                file={frontImage}
                onFileSelect={(file) => {
                  const preview = URL.createObjectURL(file);
                  setFrontImage({ file, preview });
                  setErrors(prev => ({ ...prev, frontImage: undefined }));
                }}
                onRemove={() => {
                  if (frontImage?.preview) URL.revokeObjectURL(frontImage.preview);
                  setFrontImage(null);
                }}
              />
              <UploadCard
                title="Back Side"
                file={backImage}
                onFileSelect={(file) => {
                  const preview = URL.createObjectURL(file);
                  setBackImage({ file, preview });
                  setErrors(prev => ({ ...prev, backImage: undefined }));
                }}
                onRemove={() => {
                  if (backImage?.preview) URL.revokeObjectURL(backImage.preview);
                  setBackImage(null);
                }}
              />
            </div>
            {(errors.frontImage || errors.backImage) && (
              <p className="text-red-500 text-xs mt-1">Both front and back are required</p>
            )}
          </div>

          {/* Security Notice - Capsule Style */}
          <div className="flex items-center justify-center">
            <div className="flex items-center gap-2 bg-[#F8FAFC] rounded-full px-4 py-2">
              <Lock className="w-3.5 h-3.5 text-[#022B60]" />
              <span className="text-xs text-gray-600">Your data is encrypted & secure</span>
            </div>
          </div>

          {/* Single CTA Button - Full Width */}
          <Button
            onClick={handleSubmit}
            disabled={isLoading}
            className="w-full bg-[#FF751F] hover:bg-[#E96A19] text-white h-12 rounded-xl font-semibold shadow-lg shadow-[#FF751F]/25 transition-all active:scale-95 mt-2"
          >
            {isLoading ? 'Verifying...' : 'Verify & Continue'}
          </Button>
        </div>
      </div>
    </div>
  );
}