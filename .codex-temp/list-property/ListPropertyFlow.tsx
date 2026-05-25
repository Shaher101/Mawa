import { useState } from 'react';
import { CheckOwnerVerificationScreen } from './CheckOwnerVerificationScreen';
import { VerifyIdentityModal } from './VerifyIdentityModal';
import { AddPropertyLocationScreen } from './AddPropertyLocationScreen';
import { AddPropertyRoomsScreen } from './AddPropertyRoomsScreen';
import { AddPropertyUtilitiesScreen } from './AddPropertyUtilitiesScreen';
import { AddPropertyPhotosScreen } from './AddPropertyPhotosScreen';
import { ReviewPropertyScreen } from './ReviewPropertyScreen';
import { PropertyPendingReviewModal } from './PropertyPendingReviewModal';

interface ListPropertyFlowProps {
  userId: string;
  onComplete: (data: any) => void;
  onCancel: () => void;
}

type FlowStep = 'verify' | 'location' | 'rooms' | 'utilities' | 'photos' | 'review' | 'success';

export function ListPropertyFlow({ userId, onComplete, onCancel }: ListPropertyFlowProps) {
  const [showVerifyModal, setShowVerifyModal] = useState(false);
 /*
  const [isVerified, setIsVerified] = useState(() => {
    const saved = localStorage.getItem('mawa_owner_verified');
    return saved === 'true';
  });
  */
  const [showSuccessModal, setShowSuccessModal] = useState(false);

   const [isVerified, setIsVerified] = useState(false);
  const [step, setStep] = useState<FlowStep>(isVerified ? 'location' : 'verify');
  const [propertyData, setPropertyData] = useState({});

  const updateData = (data: any) => {
    setPropertyData(prev => ({ ...prev, ...data }));
  };

  // Verification
  if (!isVerified && step === 'verify') {
    return (
      <>
        <CheckOwnerVerificationScreen onVerify={() => setShowVerifyModal(true)} 
           onBack={onCancel} // ✅ زر الرجوع يروح للصفحة السابقة
          />
        <VerifyIdentityModal
          isOpen={showVerifyModal}
          onClose={() => setShowVerifyModal(false)}
          onVerify={async (data) => {
            console.log('Verification data:', data);
            //localStorage.setItem('mawa_owner_verified', 'true');
            setIsVerified(true);
            setShowVerifyModal(false);
            setStep('location');
          }}
        />
      </>
    );
  }

  // Step 1: Location
  if (step === 'location') {
    return (
      <AddPropertyLocationScreen
        onNext={(data) => {
          console.log('Location Data:', data);
          updateData(data);
          setStep('rooms');
        }}
        onBack={onCancel}
      />
    );
  }

  // Step 2: Rooms
  if (step === 'rooms') {
    return (
      <AddPropertyRoomsScreen
        onNext={(data) => {
          console.log('Rooms Data:', data);
          updateData(data);
          setStep('utilities');
        }}
        onBack={() => setStep('location')}
      />
    );
  }

  // Step 3: utilities
if (step === 'utilities') {
  return (
    <AddPropertyUtilitiesScreen
      onNext={(data) => {
        updateData(data);
        setStep('photos');
      }}
      onBack={() => setStep('rooms')}
    />
  );
}

  // Step 4: photos
  if (step === 'photos') {
  return (
    <AddPropertyPhotosScreen
      onNext={(data) => {
        updateData(data);
        setStep('review');
      }}
      onBack={() => setStep('utilities')}
    />
  );
}


  // Step 5: Review
  if (step === 'review') {
    return (
      <ReviewPropertyScreen
        data={propertyData}
        onSubmit={() => setStep('success')}
        onBack={() => setStep('photos')}
      />
    );
  }

  // Step 6: Success
if (step === 'success') {
  return (
    <>
      {/* المكونات الأخرى */}
      <PropertyPendingReviewModal
        isOpen={true}
        onClose={() => {
          setStep('verify');
          onComplete(propertyData);
        }}
        onFinish={() => {
          onComplete(propertyData);
        }}
      />
    </>
  );
}

  return null;
}