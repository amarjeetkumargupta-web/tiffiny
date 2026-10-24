import * as admin from 'firebase-admin';

export interface SetRoleRequest {
  uid: string;
  phoneNumber: string;
  requestedRole: 'customer' | 'partner';
}

export interface SetRoleResponse {
  success: boolean;
  message: string;
  role?: 'customer' | 'partner';
}

/**
 * Server-side role assignment with cross-role collision prevention.
 * Enforces rule: A phone number can only ever be a customer OR a partner, never both.
 */
export async function handleSetRoleCustomClaim(
  db: admin.firestore.Firestore,
  auth: admin.auth.Auth,
  request: SetRoleRequest
): Promise<SetRoleResponse> {
  const { uid, phoneNumber, requestedRole } = request;

  // 1. Check if this phone number already exists in the other role collection
  const customerDoc = await db.collection('users').where('phone', '==', phoneNumber).limit(1).get();
  const partnerDoc = await db.collection('partners').where('phone', '==', phoneNumber).limit(1).get();

  if (requestedRole === 'partner' && !customerDoc.empty) {
    return {
      success: false,
      message: 'This number is registered as a customer. Please use Order Food to log in.',
    };
  }

  if (requestedRole === 'customer' && !partnerDoc.empty) {
    return {
      success: false,
      message: 'This number is registered as a partner. Please use Partner Login to log in.',
    };
  }

  // 2. Set the custom claim on the Firebase Auth user token
  await auth.setCustomUserClaims(uid, { role: requestedRole });

  // 3. Create or update the initial Firestore user record with this role
  if (requestedRole === 'customer') {
    await db.collection('users').doc(uid).set(
      {
        role: 'customer',
        phone: phoneNumber,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
  } else {
    await db.collection('partners').doc(uid).set(
      {
        role: 'partner',
        phone: phoneNumber,
        status: 'pending', // Starts as pending until admin approval (Section 2.4)
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
  }

  return {
    success: true,
    message: `Custom claim '${requestedRole}' successfully assigned.`,
    role: requestedRole,
  };
}
