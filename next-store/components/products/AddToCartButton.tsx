interface AddToCartButtonProps {
  adding: boolean;
  onClick: () => void;
}

export const AddToCartButton = ({ adding, onClick }: AddToCartButtonProps) => {
  return (
    <button
      onClick={onClick}
      disabled={adding}
      className={`w-full md:flex-1 lg:w-[388px] h-[48px] rounded-[4px] text-white transition-all ${adding ? "bg-gray-500 cursor-not-allowed" : "bg-black hover:bg-gray-900"
        }`}
    >
      {adding ? "Adding to cart..." : "Add to cart"}
    </button>
  );
};