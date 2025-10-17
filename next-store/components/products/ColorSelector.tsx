interface ColorSelectorProps {
  selectedColor: string;
  onChange: (color: string) => void;
  COLORS: typeof import("@/constants/colors").COLORS;
}

export const ColorSelector = ({ selectedColor, onChange, COLORS }: ColorSelectorProps) => {
  return (
    <div className="flex flex-col items-start gap-2 mt-8">
      <div className="flex gap-2">
        <span>Colors:</span>
        <span className="text-[#808080]">{selectedColor || "—"}</span>
      </div>
      <div className="flex items-center gap-3 mt-1">
        {Object.entries(COLORS).map(([name, hex]) => {
          const isSelected = selectedColor?.toLowerCase() === name.toLowerCase();
          return (
            <div key={name} className="flex flex-col items-center">
              <button
                onClick={() => onChange(name)}
                aria-label={name}
                title={name}
                className={`w-8 h-8 rounded-sm border-2 focus:outline-none transition-colors ${
                  isSelected ? "border-black" : "border-gray-300"
                }`}
                style={{ backgroundColor: hex }}
              />
              {isSelected && <div className="w-6 h-1 bg-black mt-1 rounded" />}
            </div>
          );
        })}
      </div>
    </div>
  );
};