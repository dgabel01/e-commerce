import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface CartItem {
  variantId: string;
  productId: string;
  quantity: number;
  title: string;
  price: number;
  thumbnail?: string;
  material?: string;
  color?: string;
}

interface CartStore {
  items: CartItem[];
  addItem: (item: Omit<CartItem, 'quantity'> & { quantity?: number }) => void;
  removeItem: (variantId: string) => void;
  updateQuantity: (variantId: string, quantity: number) => void;
  clearCart: () => void;
  getTotalItems: () => number;
}

export const useCartStore = create<CartStore>()(
  persist(
    (set, get) => ({
      items: [],
      
      addItem: (item) => {
        const existingItem = get().items.find(i => i.variantId === item.variantId);
        
        if (existingItem) {
          set({
            items: get().items.map(i =>
              i.variantId === item.variantId
                ? { ...i, quantity: i.quantity + (item.quantity || 1) }
                : i
            ),
          });
        } else {
          set({
            items: [...get().items, { ...item, quantity: item.quantity || 1 }],
          });
        }
      },
      
      removeItem: (variantId) => {
        set({
          items: get().items.filter(i => i.variantId !== variantId),
        });
      },
      
      updateQuantity: (variantId, quantity) => {
        if (quantity <= 0) {
          get().removeItem(variantId);
        } else {
          set({
            items: get().items.map(i =>
              i.variantId === variantId ? { ...i, quantity } : i
            ),
          });
        }
      },
      
      clearCart: () => set({ items: [] }),
      
      getTotalItems: () => {
        return get().items.reduce((total, item) => total + item.quantity, 0);
      },
    }),
    {
      name: 'cart-storage',
    }
  )
);