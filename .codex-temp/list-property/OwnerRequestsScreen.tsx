import { useState } from 'react';
import { ArrowLeft, Bell, Users, Home, MapPin, MessageCircle, CheckCircle, XCircle, Clock, Shield, GraduationCap, Calendar, ChevronRight, User, Mail, Phone } from 'lucide-react';
import { Request, Listing } from '../../lib/types';
import { Button } from '../../ui/button';
import { Badge } from '../../ui/badge';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '../../ui/dialog';

interface OwnerRequestsScreenProps {
  requests: Request[];
  listings: Listing[];
  onBack: () => void;
  onAcceptRequest: (requestId: string) => void;
  onRejectRequest: (requestId: string) => void;
  userName: string;
}

type RequestStatus = 'pending' | 'accepted' | 'under_coordination' | 'rejected';

const statusConfig = {
  pending: { label: 'Pending', color: 'bg-orange-50 text-orange-600', icon: Clock, bgIcon: '#FFF1E8' },
  accepted: { label: 'Accepted', color: 'bg-green-50 text-green-600', icon: CheckCircle, bgIcon: '#E8F5E9' },
  under_coordination: { label: 'Under Coordination', color: 'bg-blue-50 text-blue-600', icon: Shield, bgIcon: '#E3F2FD' },
  rejected: { label: 'Rejected', color: 'bg-red-50 text-red-600', icon: XCircle, bgIcon: '#FFEBEE' },
};

// Student tags (mock data - هتجيبيها من API بعدين)
const getStudentTags = (studentId: string) => [
  { label: 'Female', icon: '👩' },
  { label: 'Non-Smoker', icon: '🚭' },
  { label: 'Quiet', icon: '🔇' },
  { label: 'No Pets', icon: '🐾' },
];

export function OwnerRequestsScreen({ 
  requests, 
  listings, 
  onBack, 
  onAcceptRequest, 
  onRejectRequest,
  userName 
}: OwnerRequestsScreenProps) {
  const [activeTab, setActiveTab] = useState<RequestStatus>('pending');
  const [selectedRequest, setSelectedRequest] = useState<Request | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  const filteredRequests = requests.filter(r => r.status === activeTab);
  
  const counts = {
    pending: requests.filter(r => r.status === 'pending').length,
    accepted: requests.filter(r => r.status === 'accepted').length,
    under_coordination: requests.filter(r => r.status === 'under_coordination').length,
    rejected: requests.filter(r => r.status === 'rejected').length,
  };

  const tabs: { id: RequestStatus; label: string }[] = [
    { id: 'pending', label: 'Pending' },
    { id: 'accepted', label: 'Accepted' },
    { id: 'under_coordination', label: 'Under Coordination' },
    { id: 'rejected', label: 'Rejected' },
  ];

  const handleOpenModal = (request: Request) => {
    setSelectedRequest(request);
    setIsModalOpen(true);
  };

  const handleAccept = (requestId: string) => {
    onAcceptRequest(requestId);
    setIsModalOpen(false);
  };

  const handleReject = (requestId: string) => {
    onRejectRequest(requestId);
    setIsModalOpen(false);
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-8">
      
      {/* ============================================ */}
      {/* HEADER */}
      {/* ============================================ */}
      <div className="bg-[#022B60] px-6 pt-12 pb-6">
        <div className="flex items-center justify-between mb-4">
          <button onClick={onBack} className="text-white/70">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <button className="w-9 h-9 rounded-full bg-white/10 flex items-center justify-center">
            <Bell className="w-4 h-4 text-white/70" />
          </button>
        </div>
        
        <div>
          <h1 className="text-2xl font-bold text-white">Requests</h1>
          <p className="text-white/60 text-sm mt-1">Review student requests for your listings</p>
        </div>
      </div>

      {/* ============================================ */}
      {/* TABS - منظمة مع أعداد */}
      {/* ============================================ */}
      <div className="px-6 mt-6">
        <div className="flex gap-2 border-b border-gray-200">
          {tabs.map((tab) => {
            const isActive = activeTab === tab.id;
            const count = counts[tab.id];
            const config = statusConfig[tab.id];
            
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`pb-3 px-4 text-sm font-medium transition-all relative ${
                  isActive
                    ? 'text-[#FF751F]'
                    : 'text-gray-500 hover:text-gray-700'
                }`}
              >
                {tab.label}
                {count > 0 && (
                  <span className={`ml-1.5 text-xs ${isActive ? 'text-[#FF751F]' : 'text-gray-400'}`}>
                    ({count})
                  </span>
                )}
                {isActive && (
                  <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-[#FF751F] rounded-full" />
                )}
              </button>
            );
          })}
        </div>
      </div>

      {/* ============================================ */}
      {/* REQUESTS LIST - بطاقات مبسطة */}
      {/* ============================================ */}
      <div className="px-6 mt-6 space-y-3">
        {filteredRequests.length === 0 ? (
          <div className="bg-white rounded-2xl p-12 text-center border border-gray-100">
            <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-4">
              <MessageCircle className="w-8 h-8 text-gray-400" />
            </div>
            <p className="text-gray-500 text-sm">No {activeTab} requests</p>
            <p className="text-gray-400 text-xs mt-1">When students request your properties, they'll appear here</p>
          </div>
        ) : (
          filteredRequests.map((request) => {
            const listing = listings.find(l => l.id === request.listingId);
            const status = statusConfig[request.status as RequestStatus];
            const StatusIcon = status.icon;
            
            return (
              <div
                key={request.id}
                onClick={() => handleOpenModal(request)}
                className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm hover:shadow-md transition-all cursor-pointer active:scale-[0.99]"
              >
                <div className="flex items-start gap-3">
                  {/* Student Avatar */}
                  <div className="w-12 h-12 rounded-full bg-[#FFF1E8] flex items-center justify-center shrink-0">
                    <span className="text-[#FF751F] font-semibold text-lg">S</span>
                  </div>
                  
                  <div className="flex-1 min-w-0">
                    {/* Header Row */}
                    <div className="flex items-start justify-between">
                      <div>
                        <h3 className="font-semibold text-gray-800">Student Name</h3>
                        <p className="text-xs text-gray-500 mt-0.5">Engineering • 3rd Year</p>
                      </div>
                      <div className={`flex items-center gap-1 px-2 py-1 rounded-full ${status.color}`}>
                        <StatusIcon className="w-3 h-3" />
                        <span className="text-xs font-medium">{status.label}</span>
                      </div>
                    </div>
                    
                    {/* Property Info - سطر واحد */}
                    <div className="flex items-center gap-2 mt-2 text-xs text-gray-500">
                      <Home className="w-3 h-3" />
                      <span className="truncate">{listing?.title || 'Property'}</span>
                      <span>•</span>
                      <span>{listing?.pricePerPerson?.toLocaleString()} EGP</span>
                    </div>
                    
                    {/* Date */}
                    <div className="flex items-center gap-1 mt-2 text-xs text-gray-400">
                      <Calendar className="w-3 h-3" />
                      <span>{new Date(request.createdAt).toLocaleDateString()}</span>
                    </div>
                  </div>
                  
                  <ChevronRight className="w-5 h-5 text-gray-300 shrink-0" />
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* ============================================ */}
      {/* DETAILS MODAL - عند الضغط على الطلب */}
      {/* ============================================ */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="max-w-md rounded-3xl p-0 overflow-hidden">
          {selectedRequest && (
            <>
              {/* Modal Header */}
              <div className={`p-5 ${
                selectedRequest.status === 'pending' ? 'bg-orange-50' :
                selectedRequest.status === 'accepted' ? 'bg-green-50' :
                selectedRequest.status === 'under_coordination' ? 'bg-blue-50' : 'bg-red-50'
              }`}>
                <div className="flex items-center gap-3">
                  <div className="w-14 h-14 rounded-full bg-white flex items-center justify-center shadow-sm">
                    <span className="text-[#FF751F] font-bold text-xl">S</span>
                  </div>
                  <div>
                    <h2 className="font-bold text-gray-800 text-lg">Student Name</h2>
                    <p className="text-sm text-gray-500">Engineering Student</p>
                    <p className="text-xs text-gray-400">Ain Shams University • 3rd Year</p>
                  </div>
                </div>
              </div>

              <div className="p-5 space-y-5">
                {/* Student Tags */}
                <div>
                  <p className="text-xs font-medium text-gray-500 mb-2">About the student</p>
                  <div className="flex flex-wrap gap-2">
                    {getStudentTags(selectedRequest.studentId).map((tag, idx) => (
                      <span key={idx} className="px-3 py-1.5 bg-gray-100 rounded-full text-xs text-gray-600 flex items-center gap-1">
                        <span>{tag.icon}</span> {tag.label}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Property Info */}
                <div>
                  <p className="text-xs font-medium text-gray-500 mb-2">Property applied for</p>
                  <div className="bg-[#F8FAFC] rounded-2xl p-4">
                    <p className="font-medium text-gray-800">
                      {listings.find(l => l.id === selectedRequest.listingId)?.title}
                    </p>
                    <p className="text-xs text-gray-500 mt-1 flex items-center gap-1">
                      <MapPin className="w-3 h-3" />
                      {listings.find(l => l.id === selectedRequest.listingId)?.location?.address?.split(',')[0]}
                    </p>
                    <p className="text-xs text-[#FF751F] font-medium mt-2">
                      {listings.find(l => l.id === selectedRequest.listingId)?.pricePerPerson?.toLocaleString()} EGP/month
                    </p>
                  </div>
                </div>

                {/* Student Message */}
                {selectedRequest.message && (
                  <div>
                    <p className="text-xs font-medium text-gray-500 mb-2">Student's message</p>
                    <div className="bg-gray-50 rounded-2xl p-4">
                      <p className="text-sm text-gray-600 italic leading-relaxed">
                        "{selectedRequest.message}"
                      </p>
                    </div>
                  </div>
                )}

                {/* MAWA Note */}
                <div className="flex items-center gap-2 p-3 bg-blue-50 rounded-xl">
                  <Shield className="w-4 h-4 text-blue-500" />
                  <p className="text-xs text-blue-600 flex-1">
                    MAWA will coordinate the next steps after approval
                  </p>
                </div>

                {/* Actions - Only for pending */}
                {selectedRequest.status === 'pending' && (
                  <div className="flex gap-3 pt-2">
                    <button
                      onClick={() => handleAccept(selectedRequest.id)}
                      className="flex-1 bg-[#FF751F] hover:bg-[#E96A19] text-white py-3 rounded-xl font-medium transition-all active:scale-95"
                    >
                      Accept Request
                    </button>
                    <button
                      onClick={() => handleReject(selectedRequest.id)}
                      className="flex-1 bg-white border border-gray-200 text-gray-600 py-3 rounded-xl font-medium hover:bg-gray-50 transition-all"
                    >
                      Reject
                    </button>
                  </div>
                )}

                {/* Status info for non-pending */}
                {selectedRequest.status !== 'pending' && (
                  <div className="text-center py-2">
                    <p className="text-sm text-gray-500">
                      Request {selectedRequest.status === 'accepted' ? 'accepted' : selectedRequest.status === 'under_coordination' ? 'under coordination' : 'rejected'}
                    </p>
                    <p className="text-xs text-gray-400 mt-1">
                      {new Date(selectedRequest.createdAt).toLocaleDateString()}
                    </p>
                  </div>
                )}
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}