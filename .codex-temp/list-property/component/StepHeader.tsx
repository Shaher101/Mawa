// components/StepHeader.tsx
import { Clock } from 'lucide-react';

interface StepHeaderProps {
  title: string;
  description: string;
  estimatedTime: string;
}

export function StepHeader({ title, description, estimatedTime }: StepHeaderProps) {
  return (
    <div className="mb-6">
      <h2 className="text-xl font-bold text-[#022B60] mb-2">{title}</h2>
      <p className="text-sm text-gray-500 mb-2">{description}</p>
      <div className="flex items-center gap-1">
        <Clock className="w-3 h-3 text-gray-400" />
        <span className="text-xs text-gray-400">Takes about {estimatedTime}</span>
      </div>
    </div>
  );
}