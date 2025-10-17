"use client";
import { useCartStore } from "@/store/cartStore";
import { useEffect } from "react";

interface CartModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function CartModal({ isOpen, onClose }: CartModalProps) {
  const { items } = useCartStore();
  const total = items.reduce(
    (sum, item) => sum + item.quantity * item.price,
    0
  );

  useEffect(() => {
    if (isOpen) document.body.style.overflow = "hidden";
    else document.body.style.overflow = "";
  }, [isOpen]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-transparent backdrop-blur-sm bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white p-6 rounded-lg w-full max-w-md border-[2px] shadow-lg">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-xl font-semibold">Your Cart</h3>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700"
          >
            Close
          </button>
        </div>

        <div className="space-y-4 max-h-[60vh] overflow-y-auto">
          {items.length === 0 ? (
            <p className="text-center text-gray-500">Your cart is empty.</p>
          ) : (
            items.map((item) => (
              <div
                key={item.variantId}
                className="flex justify-between items-center"
              >
                <div>
                  <p className="font-medium">{item.title}</p>
                  <p className="text-sm text-gray-600">
                    Qty: {item.quantity} × €{item.price.toFixed(2)}
                  </p>
                  {item.material && (
                    <p className="text-sm text-gray-600">
                      Material: {item.material}
                    </p>
                  )}
                  {item.color && (
                    <p className="text-sm text-gray-600">
                      Color: {item.color}
                    </p>
                  )}
                </div>
                <p className="text-sm font-semibold">
                  €{(item.quantity * item.price).toFixed(2)}
                </p>
              </div>
            ))
          )}
        </div>

        {items.length > 0 && (
          <div className="mt-6 text-right">
            <p className="text-lg font-semibold">Total: €{total.toFixed(2)}</p>
            <button
              onClick={onClose}
              className="mt-4 bg-black text-white px-4 py-2 rounded hover:bg-gray-800"
            >
              Checkout
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
