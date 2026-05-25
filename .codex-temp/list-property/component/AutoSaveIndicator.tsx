// components/AutoSaveIndicator.tsx
import { Save, CheckCircle } from 'lucide-react';
import { useState, useEffect } from 'react';

export function AutoSaveIndicator() {
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setSaved(true);
      setTimeout(() => setSaved(false), 2000);
    }, 1000);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="flex items-center justify-end gap-1 mb-4">
      {saved ? (
        <>
          <CheckCircle className="w-3 h-3 text-green-500" />
          <span className="text-xs text-green-500">Draft saved</span>
        </>
      ) : (
        <>
          <Save className="w-3 h-3 text-gray-400 animate-pulse" />
          <span className="text-xs text-gray-400">Saving...</span>
        </>
      )}
    </div>
  );
}