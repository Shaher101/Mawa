import { MapPin, Bed, Home, Camera, CheckCircle } from 'lucide-react';

interface ProgressStepsProps {
  currentStep: number;
}

// ✅ 5 خطوات بدل 4
const steps = [
  { id: 1, title: 'Location', icon: MapPin },
  { id: 2, title: 'Rooms', icon: Bed },
  { id: 3, title: 'Utilities', icon: Home },
  { id: 4, title: 'Photos', icon: Camera },
  { id: 5, title: 'Review', icon: CheckCircle },
];

export function ProgressSteps({ currentStep }: ProgressStepsProps) {
  return (
    <div className="bg-white px-5 py-4 border-b border-gray-100 overflow-x-auto">
      <div className="flex items-center justify-between min-w-[500px] max-w-md mx-auto">
        {steps.map((step, index) => {
          const isActive = currentStep >= step.id;
          const isCompleted = currentStep > step.id;
          const Icon = step.icon;
          
          return (
            <div key={step.id} className="flex items-center flex-1">
              <div className="flex flex-col items-center shrink-0">
                {/* Circle with Icon */}
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                    isActive
                      ? 'bg-[#FF751F] text-white shadow-lg shadow-[#FF751F]/30'
                      : 'bg-gray-100 text-gray-400'
                  }`}
                >
                  {isCompleted ? (
                    <CheckCircle className="w-5 h-5" />
                  ) : (
                    <Icon className="w-5 h-5" />
                  )}
                </div>
                {/* Label */}
                <span
                  className={`text-xs mt-2 font-medium whitespace-nowrap ${
                    isActive ? 'text-[#FF751F]' : 'text-gray-400'
                  }`}
                >
                  {step.title}
                </span>
              </div>
              
              {/* Connecting Line */}
              {index < steps.length - 1 && (
                <div
                  className={`flex-1 h-0.5 mx-2 transition-all ${
                    currentStep > step.id ? 'bg-[#FF751F]' : 'bg-gray-200'
                  }`}
                />
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}