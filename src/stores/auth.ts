import { create } from 'zustand';
import { Session } from '@supabase/supabase-js';
import { supabase } from '../lib/supabase';

interface AuthState {
  session: Session | null;
  profile: any | null;
  setSession: (session: Session | null) => void;
  setProfile: (profile: any | null) => void;
  signOut: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  session: null,
  profile: null,
  setSession: (session) => set({ session }),
  setProfile: (profile) => set({ profile }),
  signOut: async () => {
    await supabase.auth.signOut();
    set({ session: null, profile: null });
  },
}));