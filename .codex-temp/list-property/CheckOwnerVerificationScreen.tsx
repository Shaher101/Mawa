import { Shield, ArrowRight, ArrowLeft, Lock, CheckCircle, Sparkles, Clock, Users, Star } from 'lucide-react';
import { Button } from '../../ui/button';

interface CheckOwnerVerificationScreenProps {
  onVerify: () => void;
  onBack?: () => void;
}

export function CheckOwnerVerificationScreen({ onVerify, onBack }: CheckOwnerVerificationScreenProps) {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      
      {/* ✅ Header - نفس تنسيق باقي الشاشات (أزرق) */}
      <div className="bg-[#022B60] px-6 pt-12 pb-8 rounded-b-[2rem]">
        {onBack && (
          <button 
            onClick={onBack} 
            className="text-white/80 mb-6 flex items-center gap-1 hover:text-white transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            <span className="text-sm font-medium">Back</span>
          </button>
        )}
        <h1 className="text-white text-2xl font-bold">List Your Property</h1>
        <p className="text-white/70 text-sm mt-2">
          Before listing your property, we need to verify your identity.
        </p>
      </div>

      <div className="flex-1 px-6 py-6 max-w-md mx-auto w-full">
        
        {/* ✅ Hero Card - Gradient */}
        <div className="bg-gradient-to-br from-[#fff7f2] to-white rounded-2xl p-6 mb-8 shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-[#022B60] font-semibold text-lg">One-Time Verification</h3>
              <p className="text-gray-500 text-sm mt-1">Secure your account and start listing</p>
            </div>
            <div className="relative">
              {/* Navy background card */}
              <div className="bg-[#022B60] rounded-xl p-3">
                {/* Orange Shield */}
                <div className="bg-[#FF751F] rounded-full p-2">
                  <Shield className="w-8 h-8 text-white" />
                </div>
              </div>
              {/* White check badge */}
              <div className="absolute -bottom-1 -right-1 bg-white rounded-full p-1 shadow-md">
                <CheckCircle className="w-4 h-4 text-[#022B60]" />
              </div>
            </div>
          </div>
        </div>

        {/* ✅ Benefits Cards */}
        <div className="space-y-3 mb-8">
          <div className="bg-white border border-gray-100 rounded-xl p-4 hover:border-l-[#FF751F] hover:border-l-4 transition-all">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-[#FFF1E8] flex items-center justify-center">
                <Shield className="w-5 h-5 text-[#FF751F]" />
              </div>
              <div>
                <h4 className="font-semibold text-[#022B60]">Build Trust</h4>
                <p className="text-xs text-gray-500">Verified badge increases student confidence</p>
              </div>
            </div>
          </div>

          <div className="bg-white border border-gray-100 rounded-xl p-4 hover:border-l-[#FF751F] hover:border-l-4 transition-all">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-[#FFF1E8] flex items-center justify-center">
                <Clock className="w-5 h-5 text-[#FF751F]" />
              </div>
              <div>
                <h4 className="font-semibold text-[#022B60]">Faster Approval</h4>
                <p className="text-xs text-gray-500">Verified listings get priority review</p>
              </div>
            </div>
          </div>

          <div className="bg-white border border-gray-100 rounded-xl p-4 hover:border-l-[#FF751F] hover:border-l-4 transition-all">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-[#FFF1E8] flex items-center justify-center">
                <Users className="w-5 h-5 text-[#FF751F]" />
              </div>
              <div>
                <h4 className="font-semibold text-[#022B60]">More Students</h4>
                <p className="text-xs text-gray-500">Verified owners get more inquiries</p>
              </div>
            </div>
          </div>
        </div>

        {/* ✅ Trust Indicators */}
        <div className="flex justify-between gap-4 mb-8">
          <div className="text-center flex-1">
            <div className="w-10 h-10 rounded-full bg-[#FFF1E8] flex items-center justify-center mx-auto mb-2">
              <Lock className="w-5 h-5 text-[#FF751F]" />
            </div>
            <p className="text-xs font-medium text-[#022B60]">Secure & Safe</p>
            <p className="text-xs text-gray-400 mt-1">Encrypted data</p>
          </div>
          <div className="w-px h-10 bg-gray-200" />
          <div className="text-center flex-1">
            <div className="w-10 h-10 rounded-full bg-[#FFF1E8] flex items-center justify-center mx-auto mb-2">
              <Clock className="w-5 h-5 text-[#FF751F]" />
            </div>
            <p className="text-xs font-medium text-[#022B60]">Fast Review</p>
            <p className="text-xs text-gray-400 mt-1">24-48 hours</p>
          </div>
          <div className="w-px h-10 bg-gray-200" />
          <div className="text-center flex-1">
            <div className="w-10 h-10 rounded-full bg-[#FFF1E8] flex items-center justify-center mx-auto mb-2">
              <CheckCircle className="w-5 h-5 text-[#FF751F]" />
            </div>
            <p className="text-xs font-medium text-[#022B60]">Verified Badge</p>
            <p className="text-xs text-gray-400 mt-1">Trust seal</p>
          </div>
        </div>

        {/* ✅ Verify Button - Orange CTA */}
        <Button
          onClick={onVerify}
          className="w-full bg-[#FF751F] hover:bg-[#E96A19] text-white h-14 rounded-xl font-semibold text-base shadow-lg shadow-[#FF751F]/25 transition-all active:scale-95 mb-4"
        >
          Verify Identity
          <ArrowRight className="w-5 h-5 ml-2" />
        </Button>

        {/* ✅ Security Notice - Capsule Style */}
        <div className="flex items-center justify-center gap-2 py-2 px-4 bg-[#F8FAFC] border border-gray-200 rounded-full mx-auto w-fit">
          <Lock className="w-3.5 h-3.5 text-[#022B60]" />
          <span className="text-xs text-gray-600">Encrypted & Secure</span>
        </div>
      </div>
    </div>
  );
}