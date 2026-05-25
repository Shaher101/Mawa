import { CheckCircle, Home, Sparkles, Clock, Shield, X } from 'lucide-react';
import { Button } from '../../ui/button';

interface PropertyPendingReviewModalProps {
  isOpen: boolean;
  onClose: () => void;
  onFinish: () => void;
}

export function PropertyPendingReviewModal({ isOpen, onClose, onFinish }: PropertyPendingReviewModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Backdrop with blur */}
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      
      {/* Modal Content - نفس تصميم VerifyIdentityModal */}
      <div className="relative bg-white rounded-2xl w-full max-w-md max-h-[90vh] overflow-y-auto animate-in fade-in zoom-in-95 duration-200 shadow-2xl">
        
        {/* Close Button - فوق يمين */}
        <button 
          onClick={onClose} 
          className="absolute top-4 right-4 z-10 w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 hover:text-gray-600"
        >
          <X className="w-4 h-4" />
        </button>

        {/* Content */}
        <div className="pt-8 pb-6 px-6">
          
          {/* Hero Section - Centered */}
          <div className="text-center mb-6">
            <div className="w-20 h-20 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-4">
              <CheckCircle className="w-10 h-10 text-green-500" />
            </div>
            <h2 className="text-xl font-bold text-[#022B60]">Property Submitted! 🎉</h2>
            <p className="text-sm text-gray-500 mt-1">
              Your property has been successfully submitted for review.
            </p>
          </div>

          {/* What's next Section - نفس تصميم VerifyIdentityModal */}
          <div className="bg-[#F8FAFC] rounded-2xl p-4 border border-gray-100 mb-5">
            <div className="flex items-center gap-2 mb-3">
              <div className="w-8 h-8 rounded-full bg-[#FFF1E8] flex items-center justify-center">
                <Sparkles className="w-4 h-4 text-[#FF751F]" />
              </div>
              <h3 className="font-semibold text-[#022B60] text-sm">What's next?</h3>
            </div>
            <div className="space-y-3">
              <div className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-[#FFF1E8] flex items-center justify-center mt-0.5">
                  <Clock className="w-3 h-3 text-[#FF751F]" />
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-800">Review Process</p>
                  <p className="text-xs text-gray-500">Our team will review within 24 hours</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-[#FFF1E8] flex items-center justify-center mt-0.5">
                  <Shield className="w-3 h-3 text-[#FF751F]" />
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-800">Verification Check</p>
                  <p className="text-xs text-gray-500">We'll verify all provided information</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-[#FFF1E8] flex items-center justify-center mt-0.5">
                  <CheckCircle className="w-3 h-3 text-[#FF751F]" />
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-800">Get Notified</p>
                  <p className="text-xs text-gray-500">You'll receive a notification once approved</p>
                </div>
              </div>
            </div>
          </div>

          {/* Info Box - نفس تصميم VerifyIdentityModal */}
          <div className="bg-gray-50 rounded-xl p-3 flex items-center gap-2 mb-6">
            <Shield className="w-4 h-4 text-gray-400" />
            <p className="text-xs text-gray-500">
              Your listing is now pending review. We'll notify you once it's approved.
            </p>
          </div>

          {/* Buttons */}
          <div className="flex gap-3">
            <Button
              onClick={onClose}
              variant="outline"
              className="flex-1 border-gray-200 text-gray-600 h-11 hover:bg-gray-100 hover:text-gray-800 hover:border-gray-300 transition-all"
            >
              Close
            </Button>
            <Button
              onClick={() => {
                onFinish();
                onClose();
              }}
              className="flex-1 bg-[#FF751F] hover:bg-[#E96A19] text-white h-11 rounded-xl font-semibold shadow-lg shadow-[#FF751F]/25 transition-all active:scale-95"
            >
              <Home className="w-4 h-4 mr-2" />
              Dashboard
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}