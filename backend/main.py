from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from database import engine, get_db, Base
from models import User, Contact
from schemas import (
    ContactCreate, ContactResponse, ContactBase,
    UserCreate, UserLogin, UserResponse
)

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Contact Management API")

# CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==================== USER ENDPOINTS ====================


# creer un compte (retourne le username email id)
@app.post("/register", response_model=UserResponse)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    # Check if username exists
    db_user = db.query(User).filter(User.username == user.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Utilisateur déjà existant")
    
    # Check if email exists
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email déjà utilisé")
    
    db_user = User(
        username=user.username,
        password=user.password,
        email=user.email
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
#connexion (retourne un message de succes et les infos de l'utilisateur)
@app.post("/login")
def login_user(credentials: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == credentials.username).first()
    if not user or user.password != credentials.password:
        raise HTTPException(status_code=401, detail="Identifiants incorrects")
    
    return {
        "message": "Connexion réussie",
        "user": {
            "id": user.id,
            "username": user.username,
            "email": user.email
        }
    }

# ==================== CONTACT ENDPOINTS ====================

# creer un contact (retourne le contact cree) (on doit ajouter le username dans les parametres de la requete)
@app.post("/contacts", response_model=ContactResponse)
def create_contact(contact: ContactCreate, username: str, db: Session = Depends(get_db)):
    # Verify user exists
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur non trouvé")
    
    # Check if phone already exists for this user
    existing = db.query(Contact).filter(
        Contact.phone == contact.phone,
        Contact.owner_username == username
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Ce numéro de téléphone existe déjà")
    
    db_contact = Contact(
        name=contact.name,
        phone=contact.phone,
        email=contact.email,
        address=contact.address,
        owner_username=username
    )
    db.add(db_contact)
    db.commit()
    db.refresh(db_contact)
    return db_contact

# obtenir tous les contacts d'un utilisateur (retourne une liste de contacts) (on doit ajouter le username dans les parametres de la requete)
@app.get("/contacts", response_model=List[ContactResponse])
def get_all_contacts(username: str, db: Session = Depends(get_db)):
    contacts = db.query(Contact).filter(Contact.owner_username == username).all()
    return contacts
    
# modifier un contact par son id (retourne le contact modifie) (on doit ajouter le username dans les parametres de la requete)
@app.put("/contacts/{contact_id}", response_model=ContactResponse)
def update_contact(
    contact_id: int,
    contact_data: ContactBase,
    username: str,
    db: Session = Depends(get_db)
):
    contact = db.query(Contact).filter(
        Contact.id == contact_id,
        Contact.owner_username == username
    ).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact non trouvé")
    
    # Check if new phone already exists (excluding current contact)
    if contact_data.phone != contact.phone:
        existing = db.query(Contact).filter(
            Contact.phone == contact_data.phone,
            Contact.owner_username == username,
            Contact.id != contact_id
        ).first()
        if existing:
            raise HTTPException(status_code=400, detail="Ce numéro existe déjà")
    
    contact.name = contact_data.name
    contact.phone = contact_data.phone
    contact.email = contact_data.email
    contact.address = contact_data.address
    
    db.commit()
    db.refresh(contact)
    return contact

# supprimer un contact par son id (retourne un message de succes) (on doit ajouter le username dans les parametres de la requete)
@app.delete("/contacts/{contact_id}")
def delete_contact(contact_id: int, username: str, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(
        Contact.id == contact_id,
        Contact.owner_username == username
    ).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact non trouvé")
    
    db.delete(contact)
    db.commit()
    return {"message": "Contact supprimé avec succès"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)