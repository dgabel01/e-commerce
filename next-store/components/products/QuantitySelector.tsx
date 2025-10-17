interface QuantitySelectorProps {
  quantity: number;
  setQuantity: (q: number) => void;
}

export const QuantitySelector = ({ quantity, setQuantity }: QuantitySelectorProps) => {
  const dec = () => setQuantity(Math.max(1, quantity - 1));
  const inc = () => setQuantity(quantity + 1);

  return (
    <div className="flex items-center border border-gray-300 rounded">
      <button onClick={dec} className="px-3 py-2 text-lg">
        -
      </button>
      <div className="px-4 py-2">{quantity}</div>
      <button onClick={inc} className="px-3 py-2 text-lg">
        +
      </button>
    </div>
  );
};