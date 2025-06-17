"""
Script to verify the model file's integrity and compatibility.
"""
import os
import sys
import pickle
import joblib

def check_model_file(filepath):
    print(f"\nChecking model file: {filepath}")
    print(f"File size: {os.path.getsize(filepath) / (1024 * 1024):.2f} MB")
    
    # Check if file exists
    if not os.path.exists(filepath):
        print("Error: File does not exist!")
        return False
    
    # Try to open and read the file
    try:
        with open(filepath, 'rb') as f:
            header = f.read(100)
            print(f"File header: {header[:50]}...")
    except Exception as e:
        print(f"Error reading file: {e}")
        return False
    
    # Try loading with pickle
    print("\nAttempting to load with pickle:")
    try:
        with open(filepath, 'rb') as f:
            model = pickle.load(f)
        print("✅ Successfully loaded with pickle")
        print(f"Model type: {type(model)}")
        return True
    except Exception as e:
        print(f"❌ Pickle load failed: {e}")
    
    # Try loading with joblib
    print("\nAttempting to load with joblib:")
    try:
        model = joblib.load(filepath)
        print("✅ Successfully loaded with joblib")
        print(f"Model type: {type(model)}")
        return True
    except Exception as e:
        print(f"❌ Joblib load failed: {e}")
    
    return False

if __name__ == "__main__":
    model_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'oral_cancer_model.pkl')
    print(f"Python version: {sys.version}")
    print(f"Joblib version: {joblib.__version__ if 'joblib' in sys.modules else 'N/A'}")
    
    success = check_model_file(model_path)
    if not success:
        print("\n❌ Model file could not be loaded with any method")
        print("\nPossible solutions:")
        print("1. Make sure the model file is not corrupted")
        print("2. Check if the model was saved with a different version of Python/scikit-learn")
        print("3. Try re-saving the model with the current environment")
        sys.exit(1)
    else:
        print("\n✅ Model file appears to be valid")
