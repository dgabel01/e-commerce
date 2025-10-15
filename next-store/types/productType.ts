export interface Product {
  id: string;
  title: string;
  handle: string;
  description?: string;
  thumbnail?: string;
  variants?: { prices: { amount: number; currency_code: string }[] }[];
}