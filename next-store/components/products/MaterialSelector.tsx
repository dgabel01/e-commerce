interface MaterialSelectorProps {
  currentMaterial: string;
  materialOptions: string[];
  onChange: (material: string) => void;
}

export const MaterialSelector = ({ currentMaterial, materialOptions, onChange }: MaterialSelectorProps) => {
  if (materialOptions.length === 0) return null;

  return (
    <div className="flex flex-col items-start gap-2 mt-8">
      <div className="flex gap-2">
        <span>Materials</span>
        <span className="text-[#808080]">{currentMaterial}</span>
      </div>
      <select
        value={currentMaterial}
        onChange={(e) => onChange(e.target.value)}
        className="border rounded px-3 py-2 text-sm cursor-pointer md:w-[243px] h-[48px]"
      >
        {materialOptions.map((mat) => (
          <option key={mat} value={mat}>
            {mat}
          </option>
        ))}
      </select>
    </div>
  );
};