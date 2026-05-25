import { LayoutGrid, DoorOpen, Monitor, DoorClosed } from 'lucide-react';

interface FeatureChipProps {
  type: 'window' | 'balcony' | 'desk' | 'wardrobe';
  active: boolean;
  onToggle: () => void;
}

const iconMap = {
  window: <LayoutGrid className="w-3.5 h-3.5" />,
  balcony: <DoorOpen className="w-3.5 h-3.5" />,
  desk: <Monitor className="w-3.5 h-3.5" />,
  wardrobe: <DoorClosed className="w-3.5 h-3.5" />,
};

const labelMap = {
  window: 'Window',
  balcony: 'Balcony',
  desk: 'Desk',
  wardrobe: 'Wardrobe',
};

export function FeatureChip({ type, active, onToggle }: FeatureChipProps) {
  return (
    <button
      onClick={onToggle}
      className={`px-4 py-2 rounded-full text-sm font-medium transition-all flex items-center gap-2 ${
        active
          ? 'bg-[#FF751F] text-white shadow-sm'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
      }`}
    >
      {iconMap[type]}
      {labelMap[type]}
    </button>
  );
}