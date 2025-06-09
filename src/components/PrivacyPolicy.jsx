// PrivacyPolicy.jsx
import React, { useEffect } from 'react';
import './PrivacyPolicy.css';

const PrivacyPolicy = () => {
  useEffect(() => {
    // Scroll to top when component mounts
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="privacy-container">
      <div className="privacy-header">
        <div className="privacy-logo">
          <h1>nYtevibe</h1>
        </div>
        <a href="/" className="back-link">← Back to Home</a>
      </div>
      
      <div className="privacy-content">
        <h1 className="privacy-title">nYtevibe Privacy Policy</h1>
        
        <div className="privacy-meta">
          <p><strong>Effective Date</strong>: January 1, 2025</p>
          <p><strong>Last Updated</strong>: January 1, 2025</p>
        </div>

        <div className="privacy-intro">
          <h2>Introduction</h2>
          <p>Welcome to nYtevibe! Your privacy is important to us. This Privacy Policy explains how nYtevibe, Inc. ("nYtevibe," "we," "us," or "our") collects, uses, shares, and protects your personal information when you use our nightlife discovery platform, including our website, mobile applications, and related services (collectively, the "Platform").</p>
          <p>By using our Platform, you agree to the collection and use of information in accordance with this Privacy Policy. If you do not agree with our policies and practices, please do not use our Platform.</p>
        </div>

        <div className="privacy-sections">
          <section>
            <h2>1. Information We Collect</h2>
            
            <h3>1.1 Information You Provide to Us</h3>
            
            <p><strong>Account Information</strong>: When you create an account, we collect:</p>
            <ul>
              <li>Name and username</li>
              <li>Email address</li>
              <li>Phone number (optional)</li>
              <li>Date of birth (for age verification)</li>
              <li>Profile photo (optional)</li>
              <li>Account preferences and settings</li>
            </ul>
            
            <p><strong>Profile Information</strong>: You may choose to provide:</p>
            <ul>
              <li>Bio or description</li>
              <li>Social media handles</li>
              <li>Favorite venues and music preferences</li>
              <li>Friend connections on the Platform</li>
            </ul>
            
            <p><strong>User-Generated Content</strong>: We collect content you create, including:</p>
            <ul>
              <li>Reviews and ratings of venues</li>
              <li>Photos and videos</li>
              <li>Comments and messages</li>
              <li>Event check-ins and attendance</li>
              <li>Lists and saved venues</li>
            </ul>
            
            <p><strong>Payment Information</strong>: For premium services and transactions:</p>
            <ul>
              <li>Credit/debit card information (processed by secure third-party payment processors)</li>
              <li>Billing address</li>
              <li>Transaction history</li>
              <li>Subscription details</li>
            </ul>
            
            <p><strong>Communications</strong>: When you contact us:</p>
            <ul>
              <li>Support inquiries and correspondence</li>
              <li>Feedback and suggestions</li>
              <li>Survey responses</li>
              <li>Contest or promotion entries</li>
            </ul>
            
            <h3>1.2 Information We Collect Automatically</h3>
            
            <p><strong>Usage Information</strong>: We automatically collect:</p>
            <ul>
              <li>Pages and features accessed</li>
              <li>Time spent on the Platform</li>
              <li>Click-through rates and navigation paths</li>
              <li>Search queries and filters used</li>
              <li>Venue views and interactions</li>
            </ul>
            
            <p><strong>Device Information</strong>: We collect information about your device:</p>
            <ul>
              <li>Device type and model</li>
              <li>Operating system and version</li>
              <li>Unique device identifiers</li>
              <li>Mobile network information</li>
              <li>IP address</li>
              <li>Browser type and version</li>
            </ul>
            
            <p><strong>Location Information</strong>: With your permission, we collect:</p>
            <ul>
              <li>Precise geolocation data (GPS)</li>
              <li>Approximate location (IP-based)</li>
              <li>Venues you check into</li>
              <li>Location preferences and search areas</li>
            </ul>
            
            <p><strong>Log Data</strong>: Our servers automatically record:</p>
            <ul>
              <li>Access times and dates</li>
              <li>App crashes and system activity</li>
              <li>Referral URLs</li>
              <li>Error logs and performance data</li>
            </ul>
            
            <h3>1.3 Information from Third Parties</h3>
            
            <p><strong>Social Media</strong>: If you connect social accounts:</p>
            <ul>
              <li>Basic profile information</li>
              <li>Friend lists (with permission)</li>
              <li>Social interactions related to our Platform</li>
            </ul>
            
            <p><strong>Third-Party Services</strong>: We may receive information from:</p>
            <ul>
              <li>Authentication providers</li>
              <li>Analytics services</li>
              <li>Advertising partners</li>
              <li>Venue partners and event organizers</li>
            </ul>
            
            <p><strong>Other Users</strong>: Information others provide about you:</p>
            <ul>
              <li>Tags in photos or posts</li>
              <li>Invitations and friend requests</li>
              <li>Mentions in reviews or comments</li>
            </ul>
          </section>

          <section>
            <h2>2. How We Use Your Information</h2>
            
            <h3>2.1 Service Delivery</h3>
            <ul>
              <li>Provide and maintain your account</li>
              <li>Enable venue discovery and recommendations</li>
              <li>Process transactions and subscriptions</li>
              <li>Facilitate social features and connections</li>
              <li>Display relevant events and promotions</li>
            </ul>
            
            <h3>2.2 Personalization</h3>
            <ul>
              <li>Customize content based on preferences</li>
              <li>Provide location-based recommendations</li>
              <li>Suggest venues and events you may enjoy</li>
              <li>Tailor search results and filters</li>
              <li>Remember your settings and preferences</li>
            </ul>
            
            <h3>2.3 Communication</h3>
            <ul>
              <li>Send service-related announcements</li>
              <li>Respond to inquiries and support requests</li>
              <li>Provide promotional offers (with consent)</li>
              <li>Send notifications about Platform activity</li>
              <li>Alert you to friend requests and messages</li>
            </ul>
            
            <h3>2.4 Safety and Security</h3>
            <ul>
              <li>Verify user identities and prevent fraud</li>
              <li>Monitor for prohibited activities</li>
              <li>Enforce our Terms and Conditions</li>
              <li>Protect users and venue partners</li>
              <li>Comply with legal obligations</li>
            </ul>
            
            <h3>2.5 Analytics and Improvement</h3>
            <ul>
              <li>Analyze usage patterns and trends</li>
              <li>Test new features and improvements</li>
              <li>Measure advertising effectiveness</li>
              <li>Conduct research and surveys</li>
              <li>Generate aggregated insights</li>
            </ul>
            
            <h3>2.6 Legal Purposes</h3>
            <ul>
              <li>Comply with applicable laws and regulations</li>
              <li>Respond to legal requests and court orders</li>
              <li>Protect our rights and property</li>
              <li>Investigate violations and disputes</li>
              <li>Enforce our agreements</li>
            </ul>
          </section>

          <section>
            <h2>3. How We Share Your Information</h2>
            
            <h3>3.1 Public Information</h3>
            <p>The following information is public by default:</p>
            <ul>
              <li>Username and profile photo</li>
              <li>Reviews and ratings</li>
              <li>Public venue check-ins</li>
              <li>Public lists and favorites</li>
            </ul>
            <p>You can adjust privacy settings for some content.</p>
            
            <h3>3.2 With Other Users</h3>
            <ul>
              <li>Friends can see your activity (based on privacy settings)</li>
              <li>Venue owners can see reviews of their establishments</li>
              <li>Event attendees may see who else is attending</li>
              <li>Users can see aggregated venue statistics</li>
            </ul>
            
            <h3>3.3 Service Providers</h3>
            <p>We share information with trusted third parties:</p>
            <ul>
              <li>Cloud hosting and storage providers</li>
              <li>Payment processors and financial institutions</li>
              <li>Analytics and performance monitoring services</li>
              <li>Customer support and communication tools</li>
              <li>Marketing and advertising platforms</li>
            </ul>
            
            <h3>3.4 Business Partners</h3>
            <ul>
              <li>Venue partners (aggregated analytics)</li>
              <li>Event organizers (attendee information)</li>
              <li>Promotional partners (with consent)</li>
              <li>API partners (limited data access)</li>
            </ul>
            
            <h3>3.5 Legal and Safety</h3>
            <p>We may disclose information when required:</p>
            <ul>
              <li>To comply with legal obligations</li>
              <li>To respond to lawful requests by authorities</li>
              <li>To protect safety of users or the public</li>
              <li>To prevent fraud or security threats</li>
              <li>To protect our legal rights</li>
            </ul>
            
            <h3>3.6 Business Transfers</h3>
            <p>In connection with any merger, acquisition, or sale of assets, your information may be transferred to the successor entity.</p>
            
            <h3>3.7 Aggregated Information</h3>
            <p>We share non-identifiable aggregated data:</p>
            <ul>
              <li>Industry trends and insights</li>
              <li>Venue performance metrics</li>
              <li>Platform usage statistics</li>
              <li>Demographic information</li>
            </ul>
          </section>

          <section>
            <h2>4. Data Security</h2>
            
            <h3>4.1 Security Measures</h3>
            <p>We implement appropriate technical and organizational measures:</p>
            <ul>
              <li>Encryption of data in transit and at rest</li>
              <li>Secure servers and data centers</li>
              <li>Access controls and authentication</li>
              <li>Regular security audits and testing</li>
              <li>Employee training and confidentiality agreements</li>
            </ul>
            
            <h3>4.2 Your Responsibilities</h3>
            <p>You can help protect your information by:</p>
            <ul>
              <li>Using strong, unique passwords</li>
              <li>Enabling two-factor authentication</li>
              <li>Keeping login credentials confidential</li>
              <li>Reporting suspicious activity</li>
              <li>Updating your software and devices</li>
            </ul>
            
            <h3>4.3 Data Breach Notification</h3>
            <p>In the event of a data breach affecting your personal information, we will notify you in accordance with applicable law.</p>
          </section>

          <section>
            <h2>5. Your Rights and Choices</h2>
            
            <h3>5.1 Access and Portability</h3>
            <p>You have the right to:</p>
            <ul>
              <li>Access your personal information</li>
              <li>Download your data in a portable format</li>
              <li>Review your account activity</li>
              <li>See how your information is used</li>
            </ul>
            
            <h3>5.2 Correction and Deletion</h3>
            <p>You can:</p>
            <ul>
              <li>Update or correct your information</li>
              <li>Delete your account and associated data</li>
              <li>Remove specific content you've created</li>
              <li>Request deletion of certain information</li>
            </ul>
            
            <h3>5.3 Communication Preferences</h3>
            <p>You can control:</p>
            <ul>
              <li>Email notification settings</li>
              <li>Push notification preferences</li>
              <li>Marketing communications opt-out</li>
              <li>SMS messaging preferences</li>
            </ul>
            
            <h3>5.4 Privacy Settings</h3>
            <p>Manage your privacy through:</p>
            <ul>
              <li>Profile visibility controls</li>
              <li>Activity sharing preferences</li>
              <li>Location sharing settings</li>
              <li>Friend and follower permissions</li>
            </ul>
            
            <h3>5.5 Advertising Choices</h3>
            <p>You can:</p>
            <ul>
              <li>Opt-out of personalized advertising</li>
              <li>Adjust ad preferences</li>
              <li>Use ad blocker tools</li>
              <li>Control cookie settings</li>
            </ul>
          </section>

          <section>
            <h2>6. Cookies and Tracking Technologies</h2>
            
            <h3>6.1 Types of Cookies We Use</h3>
            <ul>
              <li><strong>Essential Cookies</strong>: Required for Platform functionality</li>
              <li><strong>Performance Cookies</strong>: Help us improve services</li>
              <li><strong>Functionality Cookies</strong>: Remember your preferences</li>
              <li><strong>Advertising Cookies</strong>: Deliver relevant ads</li>
            </ul>
            
            <h3>6.2 Third-Party Cookies</h3>
            <p>Our Platform may include cookies from:</p>
            <ul>
              <li>Analytics providers (Google Analytics)</li>
              <li>Advertising networks</li>
              <li>Social media platforms</li>
              <li>Payment processors</li>
            </ul>
            
            <h3>6.3 Managing Cookies</h3>
            <p>You can control cookies through:</p>
            <ul>
              <li>Browser settings</li>
              <li>Our cookie preference center</li>
              <li>Device settings</li>
              <li>Third-party opt-out tools</li>
            </ul>
            
            <h3>6.4 Do Not Track</h3>
            <p>We currently do not respond to Do Not Track signals, but you can use our privacy settings to control data collection.</p>
          </section>

          <section>
            <h2>7. Children's Privacy</h2>
            <p>Our Platform is not intended for users under 18 years of age. We do not knowingly collect personal information from anyone under 18. If we learn we have collected information from a user under 18, we will delete that information promptly.</p>
          </section>

          <section>
            <h2>8. International Data Transfers</h2>
            
            <h3>8.1 Data Location</h3>
            <p>Your information may be transferred to and processed in:</p>
            <ul>
              <li>The United States</li>
              <li>Countries where our service providers operate</li>
              <li>Jurisdictions with different privacy laws</li>
            </ul>
            
            <h3>8.2 Transfer Safeguards</h3>
            <p>We ensure appropriate safeguards for international transfers:</p>
            <ul>
              <li>Standard contractual clauses</li>
              <li>Privacy Shield compliance (where applicable)</li>
              <li>Adequate security measures</li>
              <li>Compliance with local laws</li>
            </ul>
          </section>

          <section>
            <h2>9. Data Retention</h2>
            
            <h3>9.1 Retention Periods</h3>
            <p>We retain your information for:</p>
            <ul>
              <li>Active account data: Duration of account plus 30 days</li>
              <li>Deleted content: Up to 90 days in backups</li>
              <li>Transaction records: As required by law (typically 7 years)</li>
              <li>Analytics data: 24 months</li>
              <li>Marketing data: Until opt-out plus 6 months</li>
            </ul>
            
            <h3>9.2 Deletion</h3>
            <p>When you delete your account:</p>
            <ul>
              <li>Personal information is removed within 30 days</li>
              <li>Some information may remain in backups temporarily</li>
              <li>Aggregated or anonymized data may be retained</li>
              <li>Legal obligations may require longer retention</li>
            </ul>
          </section>

          <section>
            <h2>10. California Privacy Rights</h2>
            <p>California residents have additional rights under CCPA:</p>
            <ul>
              <li>Right to know what information we collect</li>
              <li>Right to delete personal information</li>
              <li>Right to opt-out of sale of personal information</li>
              <li>Right to non-discrimination</li>
            </ul>
            <p>To exercise these rights, contact privacy@nytevibe.com</p>
          </section>

          <section>
            <h2>11. European Privacy Rights</h2>
            <p>If you are in the European Economic Area, you have rights under GDPR:</p>
            <ul>
              <li>Access to your personal data</li>
              <li>Rectification of inaccurate data</li>
              <li>Erasure ("right to be forgotten")</li>
              <li>Restriction of processing</li>
              <li>Data portability</li>
              <li>Object to processing</li>
              <li>Lodge complaints with supervisory authorities</li>
            </ul>
          </section>

          <section>
            <h2>12. Third-Party Links and Services</h2>
            <p>Our Platform may contain links to third-party websites and services. We are not responsible for their privacy practices. We encourage you to read their privacy policies before providing personal information.</p>
          </section>

          <section>
            <h2>13. Changes to This Privacy Policy</h2>
            <p>We may update this Privacy Policy from time to time. We will notify you of material changes by:</p>
            <ul>
              <li>Posting the updated policy on our Platform</li>
              <li>Sending email notifications (for material changes)</li>
              <li>Displaying in-app notifications</li>
              <li>Updating the "Last Updated" date</li>
            </ul>
            <p>Your continued use after changes constitutes acceptance.</p>
          </section>

          <section>
            <h2>14. Contact Information</h2>
            <p>For privacy-related questions or concerns:</p>
            
            <div className="contact-info">
              <p><strong>Privacy Officer</strong><br />
              nYtevibe, Inc.<br />
              Email: privacy@nytevibe.com<br />
              Address: [Company Address]<br />
              Phone: [Phone Number]</p>
              
              <p><strong>Data Protection Requests</strong>: datarequests@nytevibe.com</p>
              
              <p><strong>General Support</strong>: support@nytevibe.com</p>
              
              <p>For European users - EU Representative:<br />
              [EU Representative Details]</p>
            </div>
          </section>

          <section>
            <h2>15. Additional Provisions</h2>
            
            <h3>15.1 Venue Partner Data</h3>
            <p>If you are a venue partner, additional privacy terms may apply to business account data and analytics access.</p>
            
            <h3>15.2 Research and Surveys</h3>
            <p>Participation in research or surveys is voluntary. We will provide specific privacy notices for such activities.</p>
            
            <h3>15.3 Beta Features</h3>
            <p>Beta features may involve additional data collection. We will notify you of any special privacy considerations.</p>
            
            <h3>15.4 Law Enforcement Guidelines</h3>
            <p>We have established guidelines for law enforcement requests available at [URL].</p>
          </section>
        </div>

        <div className="privacy-footer">
          <p><strong>Your privacy matters to us. Thank you for trusting nYtevibe with your information.</strong></p>
          <p><em>This Privacy Policy is effective as of the date stated above and supersedes all previous versions.</em></p>
        </div>
      </div>
    </div>
  );
};

export default PrivacyPolicy;
