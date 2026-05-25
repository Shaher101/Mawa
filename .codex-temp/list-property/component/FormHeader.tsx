import { ChevronLeft } from 'lucide-react';

interface FormHeaderProps {
  title: string;
  onBack: () => void;
  currentStep: number;
  totalSteps: number;
}

export function FormHeader({ title, onBack, currentStep, totalSteps }: FormHeaderProps) {
  const progressPercentage = (currentStep / totalSteps) * 100;

  return (
    <div className="bg-primary px-5 pt-12 pb-5 rounded-b-[2rem] sticky top-0 z-10">
      <div className="flex items-center gap-3 mb-2">
        <button onClick={onBack} className="text-white p-1 -ml-1 hover:bg-white/10 rounded-full transition-colors">
          <ChevronLeft className="w-6 h-6" />
        </button>
        <h1 className="text-white text-xl font-semibold flex-1">{title}</h1>
        <span className="text-white/70 text-sm font-medium bg-white/10 px-3 py-1 rounded-full">
          {currentStep}/{totalSteps}
        </span>
      </div>
      
      {/* Progress Bar */}
      <div className="w-full bg-white/20 rounded-full h-1.5 mt-3">
        <div 
          className="bg-accent h-1.5 rounded-full transition-all duration-500 ease-out"
          style={{ width: `${progressPercentage}%` }}
        />
      </div>
    </div>
  );
}